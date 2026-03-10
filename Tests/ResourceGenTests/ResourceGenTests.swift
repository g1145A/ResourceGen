@testable import ResourceGen
import Testing

@Test
func extractArgumentFlags() {
  // success
  let argumetns = ["generate", "--path", "path/to/file.txt"]
  let result = try? extractArgumentFlags(.path, arguments: argumetns)
  #expect(result == "path/to/file.txt")

  // fail
  let argumetnsFail = ["generate", "--path"]
  do {
    _ = try extractArgumentFlags(.path, arguments: argumetnsFail)
  } catch {
    #expect(error.localizedDescription == "--flat not found: --path")
  }
}

