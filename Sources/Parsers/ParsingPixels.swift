@preconcurrency import Parsing

let pixelParser = Parse(input: Substring.self, PixelModel.init(rawValue:)) {
  PrefixUpTo("px")
    .compactMap(Double.init)
  "px"
}

let namedPixelParser = Parse(input: Substring.self, NamedPixel.init) {
  "--"
  Prefix { $0 != ":" }
    .map(String.init)
    .map(NameModel.init(rawValue: ))
  ": "
  pixelParser
}

let namedPixelListParser = Many {
  Skip { Many { " " } }
  namedPixelParser
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

let modeNumberNamedPixelListParser = Parse {
  Skip {
    PrefixThrough("[data-theme=\"Mode 1\"] {\n")
    PrefixThrough("/* number */\n")
  }
  namedPixelListParser
  Skip {
    Rest()
  }
}
