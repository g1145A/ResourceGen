// The Swift Programming Language
// https://docs.swift.org/swift-book

let arguments = CommandLine.arguments

if arguments.count > 1 {
  let stringCommand = arguments[1]
  switch Command(rawValue: stringCommand) {
  case .help:
    printHelp()
  case .colors:
    generateColors(arguments: arguments)
  case .constants:
    generateConstatns(arguments: arguments)
  case .fonts:
    generateFonts(arguments: arguments)
  default:
    print("Unknown command: \(stringCommand) use help to get more information")
  }
} else {
  printHelp()
}
