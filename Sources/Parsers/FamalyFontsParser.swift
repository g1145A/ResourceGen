import Foundation
@preconcurrency import Parsing


let fontFamilyNameVarModelParser = Parse(input: Substring.self, NameVarModel.init) {
  "--font-family-"
  Prefix { $0 != ":" }
    .map(String.init)
    .map(NameModel.init(rawValue:))
  ": "
  PrefixUpTo(";")
    .map(String.init)
    .map(NameModel.init(rawValue:))
  ";"
}


let fontFamilyNameVarModelListParser = Parse(input: Substring.self) {
  Whitespace()
  Many {
    fontFamilyNameVarModelParser
  } separator: {
    Whitespace()
  }
}


let mode1FontFamilyNameVarModelParser = Parse {
  Skip {
    PrefixThrough("[data-theme=\"Mode 1\"] {\n")
    PrefixThrough("/* string */")
  }
  Whitespace()
  fontFamilyNameVarModelListParser
  Skip {
    Rest()
  }
}
