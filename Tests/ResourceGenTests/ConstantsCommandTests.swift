@testable import ResourceGen
import Testing

@Test
func testCreateSwiftConstant() {
  let result = createSwiftConstant(name: "name-one", pixel: 12.0001)
  let expectaion = """
    /// value 12 px
    static let nameOne: CGFloat = 12
  """
  #expect(result == expectaion)
}

@Test
func testCreateSwiftConstants() throws {
  let expectaion = """
    /// value 12 px
    static let name: CGFloat = 12
    /// value 14 px
    static let name2: CGFloat = 14
  """

  let result = try createSwiftConstants(
    names: [
      .init(name: "name", varName: "name"),
      .init(name: "name2", varName: "name2")
    ],
    pixels: [
      .init(name: "name", pixel: 12),
      .init(name: "name2", pixel: 14)
    ]
  )
  #expect(result == expectaion)
}
