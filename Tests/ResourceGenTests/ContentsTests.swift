@testable import ResourceGen
import Testing

@Test
func testCreateContents() throws {
  let result = try createContents(light: .init(red: "red", green: "green", blue: "alpha", alpha: nil), dark: nil)
  
  let expect = Contents(
    colors: [
      .init(
        color: .init(
          colorSpace: .sRGB,
          components: .init(red: "red", green: "green", blue: "alpha", alpha: nil)
        ),
        idiom: .universal,
        appearances: nil
      )
    ],
    info: .init(
      author: .xcode,
      version: 1
    )
  )
  
  #expect(result == expect)
}

@Test
func testCreateContentsDark() throws {
  let result = try createContents(
    light: .init(red: "red", green: "green", blue: "alpha", alpha: nil),
    dark: .init(red: "dark", green: "green", blue: "alpha", alpha: nil)
  )
  
  let expect = Contents(
    colors: [
      .init(
        color: .init(
          colorSpace: .sRGB,
          components: .init(red: "red", green: "green", blue: "alpha", alpha: nil)
        ),
        idiom: .universal,
        appearances: nil
      ),
      .init(
        color: .init(
          colorSpace: .sRGB,
          components: .init(red: "dark", green: "green", blue: "alpha", alpha: nil)
        ),
        idiom: .universal,
        appearances: [
          .init(
            appearance: .luminosity,
            value: .dark
          )
        ]
      )
    ],
    info: .init(
      author: .xcode,
      version: 1
    )
  )
  
  #expect(result == expect)
}
