import Foundation

enum Command: String {
  case help
  case colors
  case constants
  case fonts
}

enum Flag: String {
  case path = "--path"
  case output = "--output"
}

enum ScriptError: Error, LocalizedError {
  case message(String)

  var errorDescription: String? {
    switch self {
    case let .message(string):
      return string
    }
  }
}

func extractArgumentFlags(_ flag: Flag, arguments: [String]) throws -> String {
  if let pathIndex = arguments.firstIndex(of: flag.rawValue), pathIndex + 1 < arguments.count {
    return arguments[pathIndex + 1]
  }

  throw ScriptError.message("--flat not found: \(flag.rawValue)")
}
