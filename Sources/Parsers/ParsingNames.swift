@preconcurrency import Parsing

let nameVarModelParser = Parse(input: Substring.self, NameVarModel.init) {
  "--"
  Prefix { $0 != ":" }
    .map(String.init)
    .map(NameModel.init(rawValue:))
  ": var(--"
  PrefixUpTo(");")
    .map(String.init)
    .map(NameModel.init(rawValue:))
  ");"
}

let modelTypeParser = OneOf {
  fontNamedVersionParser.map(ModelType.version)
  fontNameVarModelParser.map(ModelType.font)
  Parse {
    namedHexParser.map(ModelType.namedHex)
    ";"
  }
  nameVarModelParser.map(ModelType.nameVar)
}

let modelTypeParserListParser = Parse(input: Substring.self) {
  Whitespace()
  Many {
    modelTypeParser
  } separator: {
    Whitespace()
  }
}

let namedVarModelListParser = Many {
  Skip { Many { " " } }
  nameVarModelParser
} separator: {
  Skip {
    "\n"
    Whitespace()
  }
} terminator: {
  Skip {
    Whitespace()
  }
}

let lightModeColorsParser = Parse {
  Skip {
    PrefixThrough("[data-theme=\"Light\"] {\n")
    PrefixThrough("/* color */")
  }
  Whitespace()
  modelTypeParserListParser
  Skip {
    Rest()
  }
}

let darkModeColorsParser = Parse {
  Skip {
    PrefixThrough("[data-theme=\"Dark\"] {\n")
    PrefixThrough("/* color */")
  }
  Whitespace()
  modelTypeParserListParser
  Skip {
    Rest()
  }
}

let mobileNumbersModelTypeListParser = Parse {
  Skip {
    PrefixThrough("[data-theme=\"Mobile\"] {")
    PrefixThrough("/* number */")
  }
  modelTypeParserListParser
  Skip {
    Rest()
  }
}

let mobileStringModelTypeListParser = Parse {
  Skip {
    PrefixThrough("[data-theme=\"Mobile\"] {")
    PrefixThrough("/* string */")
  }
  modelTypeParserListParser
  Skip {
    Rest()
  }
}

let mobileNamedModeListParser = Parse {
  Skip {
    PrefixThrough("[data-theme=\"Mobile\"] {")
    PrefixThrough("/* number */")
  }
  Whitespace()
  namedVarModelListParser
  Skip {
    Rest()
  }
}
