@testable import ResourceGen
import Testing
import CasePaths

@Test
func testPixelParser() throws {
  let string = "0px"[...]
  let result = try pixelParser.parse(string)
  #expect(result == 0)

  let string2 = "20.02px"[...]
  let result2 = try pixelParser.parse(string2)
  #expect(result2 == 20.02)

  let string3 = "-20.02px"[...]
  let result3 = try pixelParser.parse(string3)
  #expect(result3 == -20.02)
}

@Test
func testNamedPixelParser() throws {
  let string = "--color-blue-10: 12px"[...]
  let result = try namedPixelParser.parse(string)
  #expect(result.name == "color-blue-10")
  #expect(result.pixel == 12)
}

@Test
func testNamedOrPixelParser() throws {
  let stringPX = "--color-blue-10: 12px;"[...]
  let resultPx = try namedOrPixelParser.parse(stringPX)
  #expect(resultPx[case: \.pixel]?.name == "color-blue-10")
  #expect(resultPx[case: \.pixel]?.pixel == 12)
  
  
  let stringName = "--color-blue-10: 12;"[...]
  let resultName = try namedOrPixelParser.parse(stringName)
  #expect(resultName[case: \.name]?.first == "color-blue-10")
  #expect(resultName[case: \.name]?.second == "12")
}

@Test
func testNamedOrPixelListParser() throws {
  let string = """
   --font-line-height-88: 88px;
   --font-size-10: 10; 
   --gap-0: 0px;
  """[...]

  let result = try namedORPixelListParser.parse(string)
  #expect(result.count == 3)
}

@Test
func testNamedPixelListParser() throws {
  let string = """
   --font-line-height-88: 88px;
   --font-size-10: 10px; 
   --gap-0: 0px;
  """[...]

  let result = try namedPixelListParser.parse(string)
  #expect(result.count == 3)
}

@Test
func testHexParser() throws {
  // wiht alpha
  let string = "#020304e5"[...]
  let result = try hexParser.parse(string)
  #expect(result.red == "0x02")
  #expect(result.green == "0x03")
  #expect(result.blue == "0x04")
  #expect(result.alpha == "0.898")

  // without alpha
  let string2 = "#020304"[...]
  let result2 = try hexParser.parse(string2)
  #expect(result2.red == "0x02")
  #expect(result2.green == "0x03")
  #expect(result2.blue == "0x04")
  #expect(result2.alpha == nil)
}

@Test
func testNamedHexParser() throws {
  let string = "--color-blue-10: #f3f8fe"[...]
  let result = try namedHexParser.parse(string)
  #expect(result.hex.red == "0xf3")
  #expect(result.hex.green == "0xf8")
  #expect(result.hex.blue == "0xfe")
  #expect(result.name == "color-blue-10")
}

@Test
func testColorTypeParser() throws {
  let stringHex = "--color-blue-10: #f3f8fe;"[...]
  let resultHex = try modelTypeParser.parse(stringHex)

  #expect(resultHex[case: \.namedHex]?.hex.red == "0xf3")
  #expect(resultHex[case: \.namedHex]?.hex.green == "0xf8")
  #expect(resultHex[case: \.namedHex]?.hex.blue == "0xfe")
  #expect(resultHex[case: \.namedHex]?.name == "color-blue-10")

  let stringPrototype = "--background-primary: var(--color-grey-white);"[...]
  let resultPrototype = try modelTypeParser.parse(stringPrototype)

  #expect(resultPrototype[case: \.nameVar]?.name == "background-primary")
  #expect(resultPrototype[case: \.nameVar]?.varName == "color-grey-white")
}

@Test
func testColorTypeParserListParser() throws {
  let string = """
    --color-blue-10: #f3f8fe;
    --brand-gid-hover-secondary-alt: var(--color-blue-30-(a));
    --brand-gid-hover-secondary-fix: var(--color-blue-30-(a));
    --color-blue-100: #147bf1;
    --color-blue-110: #0070ff;
    --color-black-primary: var(--color-grey-95);
    --brand-gid-hover-secondary-alt: var(--color-blue-30-(a));
  """[...]

  let result = try modelTypeParserListParser.parse(string)
  #expect(result.count == 7)
}

@Test
func testNameOrFontVarModelListParser() throws {
  let string = """
    --brand-gid-hover-secondary-alt: var(--color-blue-30-(a));
    --brand-gid-hover-secondary-fix: var(--color-blue-30-(a));
    --font-article-body-family: var(--font-family-lora);
    --color-blue-10: #f3f8fe;
    --color-blue-100: #147bf1;
    --font-article-body-weight: var(--font-weight-medium);
    --color-blue-110: #0070ff;
    --color-black-primary: var(--color-grey-95);
    --font-article-body-letter-spacing: var(--font-letter-spacing-0);
  """[...]

  let result = try modelTypeParserListParser.parse(string)
  #expect(result.count == 9)
}

@Test
func testNamedHexParserList() throws {
  let string = """
    --color-blue-10: #f3f8fe;
    --color-blue-100: #147bf1;
    --color-blue-110: #0070ff;
  """[...]

  let result = try namedHexListParser.parse(string)
  #expect(result.count == 3)
}

@Test
func testTagsNamedHexParserListWith() throws {
  // wiht alpha
  let string = """
  [data-theme="Mode 1"] {
  /* color */
   --color-blue-10: #f3f8fe;
   --color-blue-100: #147bf1;
   --color-blue-110: #0070ff; 
    /* number */
  """[...]

  let result = try fileNamedHexListParser.parse(string)
  #expect(result.count == 3)
}

@Test
func testNamedHexParserListWith() throws {
  // wiht alpha
  let string = """
  /* color */
  [data-theme="Mode 1"] {
  /* color */
   --color-blue-10: #f3f8fe;
   --color-blue-100: #147bf1;
   --color-blue-110: #0070ff; 
    /* number */
  """[...]

  let result = try fileNamedHexListParser.parse(string)
  #expect(result.count == 3)
}

@Test
func testFileNamedPixelListParser() throws {
  // wiht alpha
  let string = """
  [data-theme="Mode 1"] {
  /* color */
  --color-yellow-90: #af8c00;
  /* number */
  --font-letter-spacing-0: 0px;
  --font-letter-spacing-1: 0.10000000149011612px;
  --font-line-height-14: 14px;
  --font-line-height-16: 16px;  
  /* string */
  """[...]

  let result = try modeNumberNamedPixelListParser.parse(string)
  #expect(result.count == 4)
}

@Test
func testFileNamedOrPixelListParser() throws {
  // wiht alpha
  let string = """
  [data-theme="Mode 1"] {
  /* color */
  --color-yellow-90: #af8c00;
  /* number */
  --font-letter-spacing-0: 0px;
  --font-letter-spacing-1: 0.10000000149011612px;
  --font-line-height-14: 14;
  --font-line-height-16: 16px;  
  /* string */
  """[...]

  let result = try modeNumberNamedOrPixelListParser.parse(string)
  #expect(result.count == 4)
}

@Test
func testFontFamilyNameVarModelParser() throws {
  let string = "--font-family-lora: Lora;"[...]
  let result = try fontFamilyNameVarModelParser.parse(string)
  #expect(result.name == "lora")
  #expect(result.varName == "Lora")
}

@Test
func testColorPrototypeParser() throws {
  let string = "--background-primary: var(--color-grey-white);"[...]
  let result = try nameVarModelParser.parse(string)
  #expect(result.name == "background-primary")
  #expect(result.varName == "color-grey-white")

  let stringA = "--brand-gid-secondary-fix: var(--color-blue-20-(a));"[...]
  let resultA = try nameVarModelParser.parse(stringA)
  #expect(resultA.name == "brand-gid-secondary-fix")
  #expect(resultA.varName == "color-blue-20-(a)")
}

@Test
func testColorPrototypeListParser() throws {
  let string = """
    --background-primary: var(--color-grey-white);
    --background-secondary: var(--color-grey-5);
    --background-tertiary: var(--color-grey-black);
  """[...]
  let result = try namedVarModelListParser.parse(string)
  #expect(result.count == 3)
}

@Test
func testLightModeColorsParser() throws {
  let string = """
  [data-theme="Light"] {
    /* color */
    --background-primary: var(--color-grey-white);
    --color-blue-10: #f3f8fe;
    --background-secondary: var(--color-grey-5);
    --background-tertiary: var(--color-grey-black);
    /* number */
    --misc-service-section-radius: var(--radius-80);
  }
  """[...]
  let result = try lightModeColorsParser.parse(string)
  #expect(result.count == 4)
}

@Test
func testMode1FontFamilyNameVarModelParser() throws {
  let string = """
  [data-theme="Mode 1"] {
  --font-family-lora: Lora;
  [data-theme="Light"] {
  /* string */
  --font-family-lora: Lora;
  --font-family-martian: Martian Mono;
  --font-family-onest: Onest;
  }
  """[...]
  let result = try mode1FontFamilyNameVarModelParser.parse(string)
  #expect(result.count == 3)
  #expect(result.first?.name == "lora")
  #expect(result[1].name == "martian")
  #expect(result.last?.name == "onest")
}

@Test
func testMobileModeColorsParser() throws {
  let string = """
  [data-theme="Mobile"] {
    /* number */
    --border-thin: var(--stroke-0,5);
    --border-regular: var(--stroke-1);
    --border-medium: var(--stroke-1,5);
    --border-bold: var(--stroke-2);
   /* string */
    --misc-service-section-radius: var(--radius-80);
  }
  """[...]
  let result = try mobileNamedModeListParser.parse(string)
  #expect(result.count == 4)
}

@Test
func testMobileNumberModelTypeParserListParser() throws {
  let string = """
  [data-theme="Mobile"] {
    /* number */
    --border-thin: var(--stroke-0,5);
    --border-regular: var(--stroke-1);
    --border-medium: var(--stroke-1,5);
    --font-article-body-letter-spacing: var(--font-letter-spacing-0);
    --font-article-body-size: var(--font-size-18);
    --font-article-body-line-height: var(--font-line-height-28);
    --font-article-h1-letter-spacing: var(--font-letter-spacing-0);
    --font-article-h1-size: var(--font-size-28);
    --font-article-h1-line-height: var(--font-line-height-34);
    --border-bold: var(--stroke-2);
   /* string */
    --misc-service-section-radius: var(--radius-80);
  }
  """[...]
  let result = try mobileNumbersModelTypeListParser.parse(string)
  #expect(result.compactMap {$0[case: \.nameVar]} .count == 4)
  #expect(result.compactMap {$0[case: \.font]} .count == 6)
}

@Test
func testMobileStringModelTypeListParser() throws {
  let string = """
  [data-theme="Mobile"] {
    /* number */
    --border-thin1: var(--stroke-0,5);
    --border-regula1r: var(--stroke-1);
    /* string */
    --font-article-body-button-version: 1.0;
    --border-thin: var(--stroke-0,5);
    --border-regular: var(--stroke-1);
    --border-medium: var(--stroke-1,5);
    --font-article-body-letter-spacing: var(--font-letter-spacing-0);
    --font-article-body-size: var(--font-size-18);
    --font-article-body-line-height: var(--font-line-height-28);
    --font-article-h1-letter-spacing: var(--font-letter-spacing-0);
    --font-article-h1-size: var(--font-size-28);
    --font-article-h1-line-height: var(--font-line-height-34);
    --border-bold: var(--stroke-2);
   /* string */
    --misc-service-section-radius: var(--radius-80);
  }
  """[...]
  let result = try mobileStringModelTypeListParser.parse(string)
  #expect(result.compactMap {$0[case: \.nameVar]} .count == 4)
  #expect(result.compactMap {$0[case: \.font]} .count == 6)
  #expect(result.compactMap {$0[case: \.version]} .count == 1)
}

@Test
func testDarkModeColorsParser() throws {
  let string = """
  [data-theme="Dark"] {
    /* color */
    --background-primary: var(--color-grey-white);
    --color-blue-10: #f3f8fe;
    --background-secondary: var(--color-grey-5);
    --background-tertiary: var(--color-grey-black);
    /* number */
    --misc-service-section-radius: var(--radius-80);
  }
  """[...]
  let result = try darkModeColorsParser.parse(string)
  #expect(result.count == 4)
}

@Test
func testNameByNameModelParser() throws {
  let string = "--font-family-lora: Lora;"[...]
  let result = try nameByNameModelParser.parse(string)
  #expect(result.first == "font-family-lora")
  #expect(result.second == "Lora")
}

@Test
func testFontNamedVersionParser() throws {
  let string = "--font-misc-article-body-button-version: 1.0;"[...]
  let result = try fontNamedVersionParser.parse(string)
  #expect(result.name == "misc-article-body-button")
  #expect(result.version == 1.0)
}

@Test
func testNamedByNameListParser() throws {
  let string = """
    --background-primary: color-grey-white;
    --background-secondary: color-grey-5;
    --background-tertiary: color-grey-black;
  """[...]
  let result = try namedByNameListParser.parse(string)
  #expect(result.count == 3)
}

@Test
func testMobileNamedByNameListParser() throws {
  let string = """
  [data-theme="Mode 1"] {
    /* color */
    --color-blue-10: #f3f8fe;
    --color-blue-100: #147bf1;
    /* string */
    --font-family-body-text: Body Text;
    --font-family-lora: Lora;
    --font-family-manrope: Manrope;
    --font-family-martian-mono: Martian Mono;
    --font-family-onest: Onest;
    --font-family-tt-interphases-pro: TT Interphases Pro;
    --font-family-tt-ricordi: TTRicordi-Fulmini;
    --font-weight-bold: Bold; 
  """[...]
  let result = try modeStringNamedByNameListParser.parse(string)
  #expect(result.count == 8)
}

@Test
func testFontNameVarModelParser() throws {
  let stringLetterSpacing = "--font-article-body-letter-spacing: var(--font-letter-spacing-0);"[...]
  let resultLetterSpacing = try fontNameVarModelParser.parse(stringLetterSpacing)
  #expect(resultLetterSpacing.font[case: \.letterSpacing] == "article-body")
  #expect(resultLetterSpacing.varName == "font-letter-spacing-0")
  
  let stringSize = "--font-article-body2-size: var(--font-size-18);"[...]
  let resultSize = try fontNameVarModelParser.parse(stringSize)
  #expect(resultSize.font[case: \.size] == "article-body2")
  #expect(resultSize.varName == "font-size-18")
  
  let stringLineHeight = "--font-article-bodyl-line-height: var(--font-line-height-28);"[...]
  let resultLineHeight = try fontNameVarModelParser.parse(stringLineHeight)
  #expect(resultLineHeight.font[case: \.lineHeight] == "article-bodyl")
  #expect(resultLineHeight.varName == "font-line-height-28")
  
  let stringFamily = "--font-article-bodyf-family: var(--font-family-lora);"[...]
  let resultFamily = try fontNameVarModelParser.parse(stringFamily)
  #expect(resultFamily.font[case: \.family] == "article-bodyf")
  #expect(resultFamily.varName == "font-family-lora")
  
  let stringWeight = "--font-article-bodyw-weight: var(--font-weight-medium);"[...]
  let resultWeight = try fontNameVarModelParser.parse(stringWeight)
  #expect(resultWeight.font[case: \.weight] == "article-bodyw")
  #expect(resultWeight.varName == "font-weight-medium")
}

@Test
func testFontElementNamePixelParser() throws {
  let stringLetterSpacing = "article-body-letter-spacing"[...]
  let resultLetterSpacing = try fontElementModelParser.parse(stringLetterSpacing)
  #expect(resultLetterSpacing[case: \.letterSpacing] == "article-body")
  
  let stringSize = "article-body2-size"[...]
  let resultSize = try fontElementModelParser.parse(stringSize)
  #expect(resultSize[case: \.size] == "article-body2")
  
  let stringLineHeight = "article-bodyl-line-height"[...]
  let resultLineHeight = try fontElementModelParser.parse(stringLineHeight)
  #expect(resultLineHeight[case: \.lineHeight] == "article-bodyl")
  
  let stringFamily = "article-bodyf-family"[...]
  let resultFamily = try fontElementModelParser.parse(stringFamily)
  #expect(resultFamily[case: \.family] == "article-bodyf")
  
  let stringWeight = "article-bodyw-weight"[...]
  let resultWeight = try fontElementModelParser.parse(stringWeight)
  #expect(resultWeight[case: \.weight] == "article-bodyw")
}

@Test
func testFontElementNamePixedlParser() throws {
  let stringLetterSpacing = "--caption-m-size: 11px;"[...]
  let resultLetterSpacing = try fontElementNamePixelParser.parse(stringLetterSpacing)
  #expect(resultLetterSpacing.font[case: \.size] == "caption-m")
  #expect(resultLetterSpacing.pixel == 11)
}


@Test
func testFontElementNameVarModelParser() throws {
  let stringLetterSpacing = "--body-l-line-height: var(--font-body-l-line-height);"[...]
  let resultLetterSpacing = try fontElementNameVarModelParser.parse(stringLetterSpacing)
  #expect(resultLetterSpacing.font[case: \.lineHeight] == "body-l")
  #expect(resultLetterSpacing.varName == "font-body-l-line-height")
}

@Test
func testfontElementWithValueParser() throws {
  let stringLetterSpacingVar = "--body-l-line-height: var(--font-body-l-line-height);"[...]
  let resultLetterSpacingVar = try fontElementWithValueParser.parse(stringLetterSpacingVar)
  #expect(resultLetterSpacingVar[case: \.fontVar]?.font[case: \.lineHeight] == "body-l")
  #expect(resultLetterSpacingVar[case: \.fontVar]?.varName == "font-body-l-line-height")
  
  let stringLineHeightPixel = "--headline-s-line-height: 30px;"[...]
  let resultLineHeightPixel = try fontElementWithValueParser.parse(stringLineHeightPixel)
  #expect(resultLineHeightPixel[case: \.fontPixel]?.font[case: \.lineHeight] == "headline-s")
  #expect(resultLineHeightPixel[case: \.fontPixel]?.pixel == 30)
}

@Test
func testFontElementWithValueListParser() throws {
  let string = """
  --body-l-size: 20px;
  --caption-l-line-height: var(--font-caption-l-line-height);
  --body-l-line-height: 28px;
  --caption-l-size: var(--font-caption-l-size);
  """[...]

  let result = try fontElementWithValueListParser.parse(string)
  #expect(result.count == 4)
  #expect(result.compactMap { $0[case: \.fontPixel] }.count == 2)
  #expect(result.compactMap { $0[case: \.fontVar] }.count == 2)
}


@Test
func testNameOrFontVarModelParser() throws {
  let stringFont = "--font-article-body-letter-spacing: var(--font-letter-spacing-0);"[...]
  let resultFont = try modelTypeParser.parse(stringFont)
  #expect(resultFont[case: \.font]?.font[case: \.letterSpacing] == "article-body")
  #expect(resultFont[case: \.font]?.varName == "font-letter-spacing-0")
  
  let stringName = "--space-2500: var(--space-200);"[...]
  let resultName = try modelTypeParser.parse(stringName)
  #expect(resultName[case: \.nameVar]?.name == "space-2500")
  #expect(resultName[case: \.nameVar]?.varName == "space-200")
}

@Test
func testFontElementWithValueListParserWith() throws {
  let stringSmall = """
  [data-theme="DynamicTypeSmall"] {
    /* number */
    --body-l-size: 16px;
    --body-l-line-height: 24px;
    --body-l-short-size: 16px;
    --body-l-short-line-height: 20px;
  }
  """[...]

  let resultSmall = try fontElementWithValueListParserWith(.small).parse(stringSmall)
  #expect(resultSmall.count == 4)
  #expect(resultSmall.compactMap { $0[case: \.fontPixel] }.count == 4)
  
  let stringMedium = """
  [data-theme="DynamicTypeMedium"] {
    /* number */
  --caption-l-size: 13px;
  --caption-l-line-height: 17px;
  --caption-l-long-size: 13px;
  --caption-l-long-line-height: 21px;
  --caption-m-size: 11px;
  --caption-m-line-height: 15px;
  }
  """[...]

  let resultMedium = try fontElementWithValueListParserWith(.medium).parse(stringMedium)
  #expect(resultMedium.count == 6)
  #expect(resultMedium.compactMap { $0[case: \.fontPixel] }.count == 6)
  
  let stringLarge = """
  [data-theme="DynamicTypeXXLarge"] {
    /* number */
  --caption-l-size: 13px;
  --caption-l-line-height: 17px;
  }
  """[...]

  let resultLarge = try fontElementWithValueListParserWith(.xxLarge).parse(stringLarge)
  #expect(resultLarge.count == 2)
  #expect(resultLarge.compactMap { $0[case: \.fontPixel] }.count == 2)
  
  let stringxLarge = """
  [data-theme="DynamicTypeXLarge"] {
    /* number */
  --caption-l-size: 13px;
  }
  """[...]

  let resultxLarge = try fontElementWithValueListParserWith(.xLarge).parse(stringxLarge)
  #expect(resultxLarge.count == 1)
  #expect(resultxLarge.compactMap { $0[case: \.fontPixel] }.count == 1)
}
