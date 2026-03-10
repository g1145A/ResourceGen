@testable import ResourceGen
import Testing
import Foundation

@Test
func testCammelCaseNameSeparateFolders() {
  let name = NameModel(rawValue: "misc-zenit-navigation-tertiary")
  let (folders, asset) = camelCaseNameSeparateFolders(name: name)
  #expect(folders == ["Misc", "Zenit", "Navigation", "Tertiary"])
  #expect(asset == "MiscZenitNavigationTertiary.colorset")

  let name2 = NameModel(rawValue: "misc-zenit-navigation-tertiary(a)")
  let (folders2, asset2) = camelCaseNameSeparateFolders(name: name2)
  #expect(folders2 == ["Misc", "Zenit", "Navigation", "TertiaryA"])
  #expect(asset2 == "MiscZenitNavigationTertiaryA.colorset")
}

@Test
func testFindPixelValue_success() throws {
  let prototype = NameVarModel(name: "name", varName: "pixel")
  let all = [
    NameVarModel(name: "name", varName: "pixel")
  ]
  let pixels: [NamedPixel] = [
    .init(name: "pixel", pixel: 12),
    .init(name: "pixel2", pixel: 22)
  ]
  
  let result = try findPixelValue(prototype: prototype, all: all, pixels: pixels)
  #expect(result == 12)
}

@Test
func testFindPixelValue_recurcive_success() throws {
  let prototype = NameVarModel(name: "name", varName: "name1")
  let all = [
    NameVarModel(name: "name", varName: "name1"),
    NameVarModel(name: "name1", varName: "pixel")
  ]
  let pixels: [NamedPixel] = [
    .init(name: "pixel", pixel: 12),
    .init(name: "pixel2", pixel: 22)
  ]
  
  let result = try findPixelValue(prototype: prototype, all: all, pixels: pixels)
  #expect(result == 12)
}

@Test
func testFindPixelValue_recurcive_fail() {
  let prototype = NameVarModel(name: "name", varName: "name1")
  let all = [
    NameVarModel(name: "name", varName: "name1"),
    NameVarModel(name: "name1", varName: "pixel3")
  ]
  let pixels: [NamedPixel] = [
    .init(name: "pixel", pixel: 12),
    .init(name: "pixel2", pixel: 22)
  ]
  
  let result = try? findPixelValue(prototype: prototype, all: all, pixels: pixels)
  #expect(result == nil)
}

@Test
func testFindColor_success() throws {
  let prototype = NameVarModel(name: "name", varName: "color")
  let all = [
    NameVarModel(name: "name", varName: "color")
  ]
  let colors = [
    NamedHexColor(name: "color1", hex: .init(red: "01", green: "01", blue: "01", alpha: "1.0")),
    NamedHexColor(name: "color", hex: .init(red: "00", green: "00", blue: "00", alpha: "1.0"))
  ]
  
  let result = try findColor(prototype: prototype, all: all, colors: colors)
  #expect(result.red == "00")
  #expect(result.green == "00")
  #expect(result.blue == "00")
  #expect(result.alpha == "1.0")
}

@Test
func testFindColor_recurcive_success() throws {
  let prototype = NameVarModel(name: "name", varName: "color")
  let all = [
    NameVarModel(name: "name", varName: "name1"),
    NameVarModel(name: "name1", varName: "color")
  ]
  let colors = [
    NamedHexColor(name: "color1", hex: .init(red: "01", green: "01", blue: "01", alpha: "1.0")),
    NamedHexColor(name: "color", hex: .init(red: "00", green: "00", blue: "00", alpha: "1.0"))
  ]
  
  let result = try findColor(prototype: prototype, all: all, colors: colors)
  #expect(result.red == "00")
  #expect(result.green == "00")
  #expect(result.blue == "00")
  #expect(result.alpha == "1.0")
}

@Test
func testFindColor_fail() {
  let prototype = NameVarModel(name: "name", varName: "color")
  let all = [
    NameVarModel(name: "name", varName: "color")
  ]
  let colors = [
    NamedHexColor(name: "color1", hex: .init(red: "01", green: "01", blue: "01", alpha: "1.0")),
    NamedHexColor(name: "color2", hex: .init(red: "00", green: "00", blue: "00", alpha: "1.0"))
  ]
  
  let result = try? findColor(prototype: prototype, all: all, colors: colors)
  #expect(result == nil)
}

@Test
func testFormatterOnedigit() {
  #expect("12" == NumberFormatter.oneDigit(12.0001))
  #expect("12.1" == NumberFormatter.oneDigit(12.06))
  #expect("12.6" == NumberFormatter.oneDigit(12.6))
}

@Test
func testCammelCaseName() {
  let result = camelCaseName(name: "one-two-three")
  #expect("oneTwoThree" == result)
}
