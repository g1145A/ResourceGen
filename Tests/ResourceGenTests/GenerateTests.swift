@testable import ResourceGen
import Testing

@Test
func testGropingPrototypeColors() {
  let ligth: [NameVarModel] = [
    .init(name: "1", varName: "01"),
    .init(name: "2", varName: "02"),
    .init(name: "3", varName: "03")
  ]
  
  let dark: [NameVarModel] = [
    .init(name: "1", varName: "10"),
    .init(name: "2", varName: "20")
  ]
  
  let result = gropingPrototypeColors(light: ligth, dark: dark)
  #expect(result.count == 3)
  #expect(result[0].light == NameVarModel(name: "1", varName: "01"))
  #expect(result[0].dark == NameVarModel(name: "1", varName: "10"))
  
  #expect(result[1].light == NameVarModel(name: "2", varName: "02"))
  #expect(result[1].dark == NameVarModel(name: "2", varName: "20"))
  
  #expect(result[2].light == NameVarModel(name: "3", varName: "03"))
  #expect(result[2].dark == nil)
}
