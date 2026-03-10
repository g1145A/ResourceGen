@preconcurrency import Parsing

let hexParser = Parse(input: Substring.self, HexColor.init) {
  "#"
  Prefix(2) { $0.isHexDigit }.map(String.init).map { "0x" + $0 }
  Prefix(2) { $0.isHexDigit }.map(String.init).map { "0x" + $0 }
  Prefix(2) { $0.isHexDigit }.map(String.init).map { "0x" + $0 }
  Optionally {
    Prefix(2) { $0.isHexDigit }
      .map(hexToAlpha)
  }
}

private func hexToAlpha(_ hex: Substring) -> String {
  let string = String(hex)
  guard let value = Int(string, radix: 16) else { return "" }
  let doubleValue = Double(value) / 255

  let alpha = (doubleValue * 1000).rounded() / 1000
  return String(alpha)
}

let namedHexParser = Parse(input: Substring.self, NamedHexColor.init) {
  "--"
  Prefix { $0 != ":" }
    .map(String.init)
    .map(NameModel.init(rawValue: ))
  ": "
  hexParser
}

let namedHexListParser = Many {
  Skip { Many { " " } }
  namedHexParser
} separator: {
  Skip {
    ";"
    Whitespace()
  }
} terminator: {
  Skip {
    Optionally { ";" }
    Whitespace()
  }
}

let fileNamedHexListParser = Parse {
  Skip {
    PrefixThrough("[data-theme=\"Mode 1\"] {\n")
    PrefixThrough("/* color */")
  }
  Whitespace()
  namedHexListParser
  Skip {
    Rest()
  }
}
