import Foundation

struct Contents: Codable, Equatable {
  let colors: [ColorEntry]
  let info: Info

  struct ColorEntry: Codable, Equatable {
    let color: Color
    let idiom: Idiom
    let appearances: [Appearance]?

    enum Idiom: String, Codable, Equatable {
      case universal
    }
    
    struct Color: Codable, Equatable {
      let colorSpace: ColorSpace
      let components: HexColor

      enum ColorSpace: String, Codable, Equatable {
        case sRGB = "srgb"
      }

      enum CodingKeys: String, CodingKey, Equatable {
        case colorSpace = "color-space"
        case components
      }
    }

    struct Appearance: Codable, Equatable {
      let appearance: Appearance
      let value: Value
      
      enum Appearance: String, Codable, Equatable {
        case luminosity
      }
      
      enum Value: String, Codable, Equatable {
        case dark
      }
    }
  }

  struct Info: Codable, Equatable {
    let author: Author
    let version: Int
    enum Author: String, Codable, Equatable {
        case xcode
    }
  }
}

func createContents(light: HexColor, dark: HexColor?) throws -> Contents {
  let lightColorEntry = Contents.ColorEntry(
  color: .init(
      colorSpace: .sRGB,
      components: light
    ),
  idiom: .universal,
  appearances: nil
)
  
  let darkColorEntry = dark.map {
    Contents.ColorEntry(
      color: .init(
        colorSpace: .sRGB,
        components: $0
      ),
      idiom: .universal,
      appearances: [
        .init(
          appearance: .luminosity,
          value: .dark
        )
      ]
    )
  }

  return .init(
    colors: [
      lightColorEntry,
      darkColorEntry
    ].compactMap { $0 },
    info: .init(author: .xcode, version: 1))
}
