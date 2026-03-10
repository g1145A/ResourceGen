import Foundation
import CasePaths

func generateConstatns(arguments: [String]) {
  do {
    let path = try extractArgumentFlags(.path, arguments: arguments)
    let output = try extractArgumentFlags(.output, arguments: arguments)
    let outputPath = output.appending("/UIConstants.swift")
    let fileContent = try readFile(at: path)

    let namedOrPixels = try modeNumberNamedOrPixelListParser.parse(fileContent)
    let namedPixels = namedOrPixels.compactMap { $0[case: \.pixel] }
    let mobileNamed = try mobileNumbersModelTypeListParser.parse(fileContent)
    let filterFontsMobileNamed = mobileNamed.compactMap { $0[case: \.nameVar] }

    let stringConstants = try createSwiftConstants(names: filterFontsMobileNamed, pixels: namedPixels)

    let string = """
    import Foundation
    /// generated file by ResourceGen

    public extension CGFloat {
    \(stringConstants)    
    }
    """
    try writeFile(text: string, filename: outputPath)

  } catch {
    print(error)
    print(error.localizedDescription)
  }
}

// MARK: Helpers

func createSwiftConstants(names: [NameVarModel], pixels: [NamedPixel]) throws -> String {
  try names.map { name in
    let pixel = try findPixelValue(prototype: name, all: names, pixels: pixels)
    if let result = createSwiftConstant(name: name.name, pixel: pixel) {
      return result
    } else {
      throw ScriptError.message("--formatting does not work: \(name.varName), pixel: \(pixel)")
    }
  }.joined(separator: "\n")
}

func createSwiftConstant(name: NameModel, pixel: PixelModel) -> String? {
  guard let pixelString = NumberFormatter.oneDigit(pixel.rawValue) else {
    return nil
  }
  let camelCaseName = camelCaseName(name: name)
  return """
    /// value \(pixelString) px
    static let \(camelCaseName): CGFloat = \(pixelString)
  """
}

func writeFile(text: String, filename: String) throws {
  let data = text.data(using: .utf8)
  let url = URL(fileURLWithPath: filename)

  print("write url: \(url.absoluteString)")
  try data?.write(to: url)
}

func findPixelValue(prototype: NameVarModel, all: [NameVarModel], pixels: [NamedPixel]) throws -> PixelModel {
  if let color = pixels.first(where: { $0.name == prototype.varName }) {
    return color.pixel
  }
  if let nextPrototype = all.first(where: { $0.name == prototype.varName }) {
    return try findPixelValue(prototype: nextPrototype, all: all, pixels: pixels)
  } else {
    throw ScriptError.message("--pixel not found: \(prototype.varName)")
  }
}
