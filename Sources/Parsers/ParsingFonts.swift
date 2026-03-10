@preconcurrency import Parsing


let nameByNameModelParser = Parse(input: Substring.self, NameByNameModel.init) {
  "--"
  Prefix { $0 != ":" }
    .until("\n")
    .map(String.init)
    .map(NameModel.init(rawValue:))
  ": "
  PrefixUpTo(";")
    .until("\n")
    .map(String.init)
    .map(NameModel.init(rawValue:))
  ";"
}

let namedByNameListParser = Parse(input: Substring.self) {
  Whitespace()
  Many {
    nameByNameModelParser
  } separator: {
    Whitespace()
  }
}

let modeStringNamedByNameListParser = Parse {
  Skip {
    PrefixThrough("[data-theme=\"Mode 1\"] {")
    PrefixThrough("/* string */")
  }
  Whitespace()
  namedByNameListParser
  Skip {
    Rest()
  }
}

// MARK: Font Element Parsing
let fontLetterSpacingParser = Parse(input: Substring.self) {
  PrefixUpTo("-letter-spacing")
    .until("\n")
    .map(String.init)
    .map(NameModel.init(rawValue:))
    .map { FontElement.letterSpacing($0) }
  "-letter-spacing"
}

let fontSizeParser = Parse(input: Substring.self) {
  PrefixUpTo("-size")
    .until("\n")
    .map(String.init)
    .map(NameModel.init(rawValue:))
    .map { FontElement.size($0) }
  "-size"
}

let fontFamilyParser = Parse(input: Substring.self) {
  PrefixUpTo("-family")
    .until("\n")
    .map(String.init)
    .map(NameModel.init(rawValue:))
    .map { FontElement.family($0) }
  "-family"
}

let fontLineHeightParser = Parse(input: Substring.self) {
  PrefixUpTo("-line-height")
    .until("\n")
    .map(String.init)
    .map(NameModel.init(rawValue:))
    .map { FontElement.lineHeight($0) }
  "-line-height"
}

let fontWeightParser = Parse(input: Substring.self) {
  PrefixUpTo("-weight")
    .until("\n")
    .map(String.init)
    .map(NameModel.init(rawValue:))
    .map { FontElement.weight($0) }
  "-weight"
}

let fontElementModelParser = Parse(input: Substring.self) {
  OneOf {
    fontLetterSpacingParser
    fontLineHeightParser
    fontSizeParser
    fontFamilyParser
    fontWeightParser
  }
}

let fontElementNamePixelParser = Parse(input: Substring.self, FontNamePixelModel.init) {
  "--"
  fontElementModelParser
  ": "
  pixelParser
  ";"
}

func fontElementWithValueListParserWith(_ value: FontDynamicTypeSize) -> AnyParser<Substring, [FontElementWithValue]> {
  Parse {
    Skip {
      PrefixThrough("[data-theme=\"\(value.rawValue)\"] {")
      PrefixThrough("/* number */")
    }
    Whitespace()
    fontElementWithValueListParser
    Whitespace()
    "}"
    OneOf {
      End()
      Skip {
        Rest()
      }
    }
  }
  .eraseToAnyParser()
}

let fontElementWithValueListParser = Parse(input: Substring.self) {
  Whitespace()
  Many {
    fontElementWithValueParser
  } separator: {
    Whitespace()
  }
}

let fontElementWithValueParser = Parse(input: Substring.self) {
  OneOf {
    fontElementNamePixelParser.map(FontElementWithValue.fontPixel)
    fontElementNameVarModelParser.map(FontElementWithValue.fontVar)
  }
}

let fontElementNameVarModelParser = Parse(input: Substring.self, FontNameVarModel.init) {
  "--"
  fontElementModelParser
  ": var(--"
  PrefixUpTo(");")
    .until("\n")
    .map(String.init)
    .map(NameModel.init(rawValue:))
  ");"
}

let fontNameVarModelParser = Parse(input: Substring.self, FontNameVarModel.init) {
  "--font-"
  fontElementModelParser
  ": var(--"
  PrefixUpTo(");")
    .until("\n")
    .map(String.init)
    .map(NameModel.init(rawValue:))
  ");"
}

let fontNamedVersionParser = Parse(input: Substring.self, NamedVersion.init) {
  "--font-"
  PrefixUpTo("-version")
    .until("\n")
    .map(String.init)
    .map(NameModel.init(rawValue:))
  "-version: "
  PrefixUpTo(";")
    .until("\n")
    .compactMap(Double.init)
    .map(VersionModel.init(rawValue:))
  ";"
}

extension Parser where Input == Substring, Output == Substring {
  func until(_ name: String) -> AnyParser<Substring, Substring> {
    flatMap {
      $0.contains(name) ? Fail<Substring, Substring>().eraseToAnyParser() : Always($0).eraseToAnyParser()
    }
    .eraseToAnyParser()
  }
}
