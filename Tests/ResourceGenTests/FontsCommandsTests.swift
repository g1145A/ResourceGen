@testable import ResourceGen
import Testing

@Test
func testCreateWeightStrut() throws {
  let result = createWeightStruct(
    items: [
      .init(
        family: "family Name1",
        weight: "weight Name1",
        size: 12,
        lineHeight: 14,
        letterSpacing: 16
      ),
      .init(
        family: "family Name2",
        weight: "weight Name2",
        size: 12,
        lineHeight: 14,
        letterSpacing: 16
      ),
      .init(
        family: "family Name1",
        weight: "weight Name1",
        size: 12,
        lineHeight: 14,
        letterSpacing: 16
      )
    ]
  )
  
  let expect = """
    public enum Weight: Sendable {
      case weightName1
      case weightName2
    }
  """
  
  #expect(result == expect)
}

@Test
func testGetFamilyStruct() throws {
  let result = createFamilyStruct(
    items: [
      .init(
        family: "family Name1",
        weight: "weightName",
        size: 12,
        lineHeight: 14,
        letterSpacing: 16
      ),
      .init(
        family: "family Name2",
        weight: "weightName",
        size: 12,
        lineHeight: 14,
        letterSpacing: 16
      ),
      .init(
        family: "family Name1",
        weight: "weightName",
        size: 12,
        lineHeight: 14,
        letterSpacing: 16
      )
    ]
  )
  
  let expect = """
      public enum Family: Sendable {
        case familyName1
        case familyName2
      }
    """
  
  #expect(result == expect)
}

@Test
func testCreateStringProperty() throws {
  let result = createStringProperty(
    key: "key-value",
    item: .init(
      family: "family name",
      weight: "weight Name",
      size: 12,
      lineHeight: 14,
      letterSpacing: 16
    )
  )
  
  let expect = """
      /// family: familyName
      /// weight: weightName
      /// size: 12.0
      /// lineHeight: 14.0
      /// letterSpacing: 16.0
      public static var keyValue: FigmaFont {
        FigmaFont(
          family: .familyName,
          weight: .weightName,
          size: 12.0,
          lineHeight: 14.0,
          letterSpacing: 16.0
        )
      }
    """
  
  #expect(result == expect)
}

@Test
func testCreateFigmaFontModel() throws {
  let namedValues: [NameByNameModel] = [
    .init(first: "first1", second: "second1"),
    .init(first: "first2", second: "second2"),
  ]
  
  let pixelValues: [NamedPixel] = [
    .init(name: "pixel12", pixel: 12),
    .init(name: "pixel14", pixel: 14),
    .init(name: "pixel16", pixel: 16)
  ]
  
  let items: [FontNameVarModel] = [
    .init(font: .family("family"), varName: "first1"),
    .init(font: .weight("weight"), varName: "first2"),
    .init(font: .size("size"), varName: "pixel12"),
    .init(font: .lineHeight("lineHeight"), varName: "pixel14"),
    .init(font: .letterSpacing("letterSpacing"), varName: "pixel16")
  ]
  let (resultKey, resultValue) = try createFigmaFontModel(
    key: "key",
    items: items,
    pixelValues: pixelValues,
    namedValues: namedValues
  )
  #expect(resultKey == "key")
  #expect(resultValue.family == "second1")
  #expect(resultValue.weight == "second2")
  #expect(resultValue.size == 12)
  #expect(resultValue.lineHeight == 14)
  #expect(resultValue.letterSpacing == 16)
}

@Test
func testGetFontValue() throws {
  let namedValues: [NameByNameModel] = [
    .init(first: "first1", second: "second1"),
    .init(first: "first2", second: "second2"),
  ]
  
  let pixelValues: [NamedPixel] = [
    .init(name: "pixel12", pixel: 12),
    .init(name: "pixel14", pixel: 14),
    .init(name: "pixel16", pixel: 16)
  ]
  
  let resultFont = try getFontValue(
    item: .init(font: .family("font"), varName: "first1"),
    pixelValues: pixelValues,
    namedValues: namedValues
  )
  #expect(resultFont == .name("second1"))
  
  let resultWeight = try getFontValue(
    item: .init(font: .weight("weight"), varName: "first2"),
    pixelValues: pixelValues,
    namedValues: namedValues
  )
  #expect(resultWeight == .name("second2"))
  
  let resultSize = try getFontValue(
    item: .init(font: .size("size"), varName: "pixel12"),
    pixelValues: pixelValues,
    namedValues: namedValues
  )
  #expect(resultSize == .pixel(12))
  
  let resultHeight = try getFontValue(
    item: .init(font: .size("height"), varName: "pixel14"),
    pixelValues: pixelValues,
    namedValues: namedValues
  )
  #expect(resultHeight == .pixel(14))
  
  let resultLetterSpacing = try getFontValue(
    item: .init(font: .size("letterSpacing"), varName: "pixel16"),
    pixelValues: pixelValues,
    namedValues: namedValues
  )
  #expect(resultLetterSpacing == .pixel(16))
}

@Test
func testConvertFontElementSize() throws {
  let sizeFont = FontElementWithValue.fontPixel(.init(font: .size("font"), pixel: 10))
  let lineHeightFont = FontElementWithValue.fontPixel(.init(font: .lineHeight("font"), pixel: 12))
  let result = try convertFontElementSize(sizeFont: sizeFont, lineHeightFont: lineHeightFont)
  #expect(result == FigmaFontSize.FontSize(size: 10, lineHeight: 12))
}

@Test
func testConvertFontElementSizes() throws {
  let sizeFont = FontElementWithValue.fontPixel(.init(font: .size("font"), pixel: 10))
  let lineHeightFont = FontElementWithValue.fontPixel(.init(font: .lineHeight("font"), pixel: 12))
  let result = try convertFontElementSizes(elements: [sizeFont, lineHeightFont])
  #expect(result.count == 1)
  #expect(result.first?.name == "font")
  #expect(result.first?.value == FigmaFontSize.FontSize(size: 10, lineHeight: 12))
}


@Test
func testConvertToStringSmallMediumLarge() throws {
  
  let small: [FontElementWithValue] = [
    .fontPixel(.init(font: .size("font"), pixel: 10)),
    .fontPixel(.init(font: .lineHeight("font"), pixel: 11)),
  ]
  
  let medium: [FontElementWithValue] = [
    .fontPixel(.init(font: .size("font"), pixel: 100)),
    .fontPixel(.init(font: .lineHeight("font"), pixel: 110)),
  ]
  
  let xLarge: [FontElementWithValue] = [
    .fontPixel(.init(font: .size("font"), pixel: 1000)),
    .fontPixel(.init(font: .lineHeight("font"), pixel: 1100)),
  ]
  
  let xxLarge: [FontElementWithValue] = [
    .fontPixel(.init(font: .size("font"), pixel: 10000)),
    .fontPixel(.init(font: .lineHeight("font"), pixel: 11000)),
  ]

  let result = try convertToString(small: small, medium: medium, xLarge: xLarge, xxLarge: xxLarge)
  
  let expected = """
  public struct FigmaFontSize: Equatable, Sendable {
    public let smallSize: Double
    public let smallLineHeight: Double
    public let mediumSize: Double
    public let mediumLineHeight: Double
    public let xLargeSize: Double
    public let xLargeLineHeight: Double
    public let xxLargeSize: Double
    public let xxLargeLineHeight: Double

    public static let font = FigmaFontSize(
      smallSize: 10.0,
      smallLineHeight: 11.0,
      mediumSize: 100.0,
      mediumLineHeight: 110.0,
      xLargeSize: 1000.0,
      xLargeLineHeight: 1100.0,
      xxLargeSize: 10000.0,
      xxLargeLineHeight: 11000.0
    )
  }
  """
  
  #expect(result == expected)
}

@Test
func testConvertToString() throws {
  let font = FigmaFontSize(
    fontName: "display-l",
    small: .init(size: 10, lineHeight: 11),
    medium: .init(size: 100, lineHeight: 110),
    xLarge: .init(size: 1000, lineHeight: 1100),
    xxLarge: .init(size: 10000, lineHeight: 11000)
  )
  let result = convertToString(font: font)
  let expected = """
    public static let displayL = FigmaFontSize(
      smallSize: 10.0,
      smallLineHeight: 11.0,
      mediumSize: 100.0,
      mediumLineHeight: 110.0,
      xLargeSize: 1000.0,
      xLargeLineHeight: 1100.0,
      xxLargeSize: 10000.0,
      xxLargeLineHeight: 11000.0
    )
  """
  #expect(result == expected)
}

@Test
func testConvertFontElement() throws {
  let smalls: [FontElementWithValue] = [
    .fontPixel(.init(font: .size("font"), pixel: 10)),
    .fontPixel(.init(font: .lineHeight("font"), pixel: 12)),
    
    .fontPixel(.init(font: .size("font2"), pixel: 20)),
    .fontPixel(.init(font: .lineHeight("font2"), pixel: 22))
  ]
  
  let mediums: [FontElementWithValue] = [
    .fontPixel(.init(font: .size("font"), pixel: 100)),
    .fontPixel(.init(font: .lineHeight("font"), pixel: 120)),
    
    .fontPixel(.init(font: .size("font2"), pixel: 200)),
    .fontPixel(.init(font: .lineHeight("font2"), pixel: 220))
  ]
  
  let xLarges: [FontElementWithValue] = [
    .fontPixel(.init(font: .size("font"), pixel: 1000)),
    .fontPixel(.init(font: .lineHeight("font"), pixel: 1200)),
    
    .fontPixel(.init(font: .size("font2"), pixel: 2000)),
    .fontPixel(.init(font: .lineHeight("font2"), pixel: 2200))
  ]
  
  let xxLarges: [FontElementWithValue] = [
    .fontPixel(.init(font: .size("font"), pixel: 10000)),
    .fontPixel(.init(font: .lineHeight("font"), pixel: 12000)),
    
    .fontPixel(.init(font: .size("font2"), pixel: 20000)),
    .fontPixel(.init(font: .lineHeight("font2"), pixel: 22000))
  ]

  let result = try convertFontElement(smalls: smalls, mediums: mediums, xLarges: xLarges, xxLarges: xxLarges)
  #expect(result.count == 2)
  #expect(result.first?.fontName == "font")
  #expect(result.first?.small == .init(size: 10, lineHeight: 12))
  #expect(result.first?.medium == .init(size: 100, lineHeight: 120))
  #expect(result.first?.xLarge == .init(size: 1000, lineHeight: 1200))
  #expect(result.first?.xxLarge == .init(size: 10000, lineHeight: 12000))
  
  #expect(result.last?.fontName == "font2")
  #expect(result.last?.small == .init(size: 20, lineHeight: 22))
  #expect(result.last?.medium == .init(size: 200, lineHeight: 220))
  #expect(result.last?.xLarge == .init(size: 2000, lineHeight: 2200))
  #expect(result.last?.xxLarge == .init(size: 20000, lineHeight: 22000))
}
