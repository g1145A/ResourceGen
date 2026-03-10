import Foundation

// return folders
func camelCaseNameSeparateFolders(name: NameModel) -> (folders: [String], name: String) {
  let folders = name.rawValue
    .split(separator: ")")
    .flatMap { $0.split(separator: "(") }
    .map { $0.capitalized }
    .joined()
    .split(separator: "-")
    .map(String.init)
  let name = folders
    .joined()
    .appending(".colorset")

  return (folders, name)
}

func camelCaseName(name: NameModel) -> String {
   name.rawValue
    .split(separator: ")")
    .flatMap { $0.split(separator: "(") }
    .flatMap { $0.split(separator: "-") }
    .flatMap { $0.split(separator: " ") }
    .enumerated()
    .map { $0 != 0 ? $1.capitalized : $1.lowercased() }
    .joined()
}

func findColor(prototype: NameVarModel, all: [NameVarModel], colors: [NamedHexColor]) throws -> HexColor {
  if let color = colors.first(where: { $0.name == prototype.varName }) {
    return color.hex
  }
  if let nextPrototype = all.first(where: { $0.name == prototype.varName }) {
    return try findColor(prototype: nextPrototype, all: all, colors: colors)
  } else {
    throw ScriptError.message("--color not found: \(prototype.varName)")
  }
}

func createCatalog(path: String) {
  let fileManager = FileManager.default

  if fileManager.fileExists(atPath: path) {
    print("Folder already exists at \(path)")
  } else {
    do {
      try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
      print("Folder created successfully at \(path)")
    } catch {
      print("Error creating folder: \(error)")
    }
  }
}

extension NumberFormatter {
  static func oneDigit(_ value: Double) -> String? {
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 1
    formatter.locale = Locale(identifier: "en_US")
    return formatter.string(from: NSNumber(value: value))
  }
}
