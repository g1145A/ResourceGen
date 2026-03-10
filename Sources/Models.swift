import Foundation
import CasePaths
import Tagged

enum NameTag {}
typealias NameModel = Tagged<NameTag, String>

enum PixelTag {}
typealias PixelModel = Tagged<PixelTag, Double>

enum VersionTag {}
typealias VersionModel = Tagged<VersionTag, Double>

// MARK: NamedVersion
struct NamedVersion: Equatable, Sendable {
  let name: NameModel
  let version: VersionModel
}

// MARK: NamedPixel
struct NamedPixel: Equatable, Sendable {
  let name: NameModel
  let pixel: PixelModel
}

// MARK: NamedHexColor
struct NamedHexColor: Equatable, Sendable {
  let name: NameModel
  let hex: HexColor
}

struct HexColor: Equatable, Sendable, Codable {
  let red: String
  let green: String
  let blue: String
  let alpha: String? // 0...1
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(red, forKey: .red)
    try container.encode(green, forKey: .green)
    try container.encode(blue, forKey: .blue)
    try container.encode(alpha ?? "1.000", forKey: .alpha)
  }
}

// MARK: NameVarModel parser
struct NameVarModel: Equatable, Sendable {
  let name: NameModel
  let varName: NameModel
}

struct NameByNameModel: Equatable, Sendable {
  let first: NameModel
  let second: NameModel
}

@CasePathable
enum ModelType: Equatable, Sendable {
  case nameVar(NameVarModel)
  case namedHex(NamedHexColor)
  case font(FontNameVarModel)
  case version(NamedVersion)
}

// MARK: Fonts
enum FontTag {}
typealias FamilyFont = Tagged<FontTag, String>
typealias WeightFont = Tagged<FontTag, String>
typealias SizeFont = Tagged<FontTag, String>
typealias LineHeightFont = Tagged<FontTag, String>
typealias LetterSpacingFont = Tagged<FontTag, String>

@CasePathable
enum FontElement: Equatable, Sendable {
  case family(NameModel)
  case weight(NameModel)
  case size(NameModel)
  case lineHeight(NameModel)
  case letterSpacing(NameModel)
  
  var value: NameModel {
    switch self {
      case let .family(value):
        return value
      case let .weight(value):
        return value
      case let .size(value):
        return value
      case let .lineHeight(value):
        return value
      case let .letterSpacing(value):
        return value
    }
  }
}

// MARK: FontNameVarModel parser
@CasePathable
enum FontDynamicTypeSize: String, Equatable, Sendable {
  case small = "DynamicTypeSmall"
  case medium = "DynamicTypeMedium"
  case xxLarge = "DynamicTypeXXLarge"
  case xLarge = "DynamicTypeXLarge"
}

@CasePathable
enum FontElementWithValue: Equatable, Sendable {
  case fontPixel(FontNamePixelModel)
  case fontVar(FontNameVarModel)
  
  var font: FontElement {
    switch self {
      case let .fontPixel(value):
        return value.font
      case let .fontVar(value):
        return value.font
    }
  }
}

struct FontNameVarModel: Equatable, Sendable {
  let font: FontElement
  let varName: NameModel
}

struct FontNamePixelModel: Equatable, Sendable {
  let font: FontElement
  let pixel: PixelModel
}

struct FigmaFontModel: Equatable, Sendable, Encodable {
  let family: NameModel
  let weight: NameModel
  let size: PixelModel
  let lineHeight: PixelModel
  let letterSpacing: PixelModel
}


struct FigmaFontSize: Equatable {
  let fontName: NameModel
  let small: FontSize
  let medium: FontSize
  let xLarge: FontSize
  let xxLarge: FontSize

  struct FontSize: Equatable {
    let size: Double
    let lineHeight: Double
  }
}
