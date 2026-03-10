import Foundation
import CasePaths
@preconcurrency import Parsing

@CasePathable
enum NameOrPixel {
  case pixel(NamedPixel)
  case name(NameByNameModel)
}


let namedOrPixelParser = Parse(input: Substring.self) {
  OneOf {
    Parse {
      namedPixelParser.map(NameOrPixel.pixel)
      ";"
    }
    nameByNameModelParser.map(NameOrPixel.name)
  }
}

let namedORPixelListParser = Many {
  Skip { Many { " " } }
  namedOrPixelParser
} separator: {
  Skip {
    Whitespace()
  }
} terminator: {
  Skip {
    Whitespace()
  }
}

let modeNumberNamedOrPixelListParser = Parse {
  Skip {
    PrefixThrough("[data-theme=\"Mode 1\"] {\n")
    PrefixThrough("/* number */\n")
  }
  namedORPixelListParser
  Skip {
    Rest()
  }
}
