import CasePaths
import Foundation

typealias GroupedColor = (light: NameVarModel, dark: NameVarModel?)

func generateColors(arguments: [String]) {
  do {
    let path = try extractArgumentFlags(.path, arguments: arguments)
    let output = try extractArgumentFlags(.output, arguments: arguments)
    let outputPath = output.appending("/CoreColors.xcassets")
    let fileContent = try readFile(at: path)

    createCatalog(path: outputPath)

    let namedHexColors = try fileNamedHexListParser.parse(fileContent)
    let lightModeColors = try lightModeColorsParser.parse(fileContent)
    let darkModeColors = try darkModeColorsParser.parse(fileContent)

    let groupedColors = gropingPrototypeColors(
      light: lightModeColors.compactMap { $0[case: \.nameVar] },
      dark: darkModeColors.compactMap { $0[case: \.nameVar] }
    )

    try createColorSet(groupedColors: groupedColors, colors: namedHexColors, in: outputPath)
    try createColorSet(
      lightColors: lightModeColors.compactMap { $0[case: \.namedHex] },
      darkColors: darkModeColors.compactMap { $0[case: \.namedHex] },
      in: outputPath
    )
  } catch {
    print(error)
    print(error.localizedDescription)
  }
}

func readFile(at path: String) throws -> String {
  let fileManager = FileManager.default
  if fileManager.fileExists(atPath: path) {
    return try String(contentsOfFile: path, encoding: .utf8)
  } else {
    throw ScriptError.message("File does not exist at path: \(path)")
  }
}

func gropingPrototypeColors(
  light: [NameVarModel],
  dark: [NameVarModel]
) -> [GroupedColor] {
  let darkDict = Dictionary(grouping: dark, by: { $0.name })

  return light.map { lightColor in
    (lightColor, darkDict[lightColor.name]?.first)
  }
}

func createColorSet(
  lightColors: [NamedHexColor],
  darkColors: [NamedHexColor],
  in folder: String
) throws {
  for lightColor in lightColors {
    let (names, assetName) = camelCaseNameSeparateFolders(name: lightColor.name)
    var path = folder
    for name in names {
      if names.last == name {
        path = path.appending("/\(assetName)")
      } else {
        path = path.appending("/\(name)")
      }
      createCatalog(path: path)
    }
    
    let darkColor = darkColors.first(where: { $0.name == lightColor.name })

    let colorInfo = try createContents(light: lightColor.hex, dark: darkColor?.hex)
    try writeJSONToFile(colorInfo: colorInfo, filename: path.appending("/Contents.json"))
  }
}

func createColorSet(
  groupedColors: [GroupedColor],
  colors: [NamedHexColor],
  in folder: String
) throws {
  for groupedColor in groupedColors {
    let (names, assetName) = camelCaseNameSeparateFolders(name: groupedColor.light.name)
    var path = folder
    for name in names {
      if names.last == name {
        path = path.appending("/\(assetName)")
      } else {
        path = path.appending("/\(name)")
      }
      createCatalog(path: path)
    }
    
    
    let lightColor = try findColor(
      prototype: groupedColor.light,
      all: groupedColors.map(\.light),
      colors: colors
    )
    
    let darkColor = try groupedColor.dark.flatMap {
      try findColor(prototype: $0, all: groupedColors.map(\.light), colors: colors)
    }

    let colorInfo = try createContents(light: lightColor, dark: darkColor)
    try writeJSONToFile(colorInfo: colorInfo, filename: path.appending("/Contents.json"))
  }
}

func writeJSONToFile<T: Codable>(colorInfo: T, filename: String) throws {
  let encoder = JSONEncoder()
  encoder.outputFormatting = [.sortedKeys, .prettyPrinted]

  let data = try encoder.encode(colorInfo)

  let url = URL(fileURLWithPath: filename)

  print("write url: \(url.absoluteString)")
  try data.write(to: url)
}
