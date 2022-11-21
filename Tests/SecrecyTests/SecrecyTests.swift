import XCTest
@testable import Secrecy

final class SecrecyTests: XCTestCase {
  func testCustomStringConvertible() {
    let wrappedBool = true
    let wrappedString = "super_secret"

    let secretBool = Secret(wrappedBool)
    let secretString = Secret(wrappedString)

    XCTAssertFalse(secretBool.description.contains(String(wrappedBool)))
    XCTAssertFalse(secretString.description.contains(wrappedString))
  }

  func testCustomDebugStringConvertible() throws {
    let wrappedBool = true
    let wrappedString = "super_secret"

    let secretBool = Secret(wrappedBool)
    let secretString = Secret(wrappedString)

    XCTAssertEqual(secretBool.debugDescription, "Secret([REDACTED Bool])")
    XCTAssertEqual(secretString.debugDescription, "Secret([REDACTED String])")
  }

  func testDecoding() throws {
    let credentialsJSON = """
    {
      "username": "user@example.com",
      "password": "very_secret"
    }
    """
    guard let data = credentialsJSON.data(using: .utf8) else {
      throw EncodingError.invalidValue(
        credentialsJSON,
        EncodingError.Context(
          codingPath: [],
          debugDescription: "Could not encode example JSON"
        )
      )
    }

    let credentials = try JSONDecoder().decode(FakeCredentials.self, from: data)

    XCTAssertEqual(credentials.password.debugDescription, "Secret([REDACTED String])")
    XCTAssertEqual(credentials.password.exposeSecret(), "very_secret")
  }

  func testEncoding() throws {
    let secret = FakeCredentials(username: "", password: Secret("very_secret"))

    let data = try JSONEncoder().encode(secret)

    let rawCredentials = try XCTUnwrap(
      String(data: data, encoding: .utf8),
      "Could not encode Data to String"
    )

    XCTAssertEqual(rawCredentials, "{\"username\":\"\",\"password\":\"very_secret\"}")
  }

  func testEncodingDecoding() throws {
    let secret = FakeCredentials(username: "", password: Secret("very_secret"))
    let data = try JSONEncoder().encode(secret)
    let decodedSecret = try JSONDecoder().decode(FakeCredentials.self, from: data)

    XCTAssertEqual(secret.username, decodedSecret.username)
    XCTAssertEqual(secret.password.exposeSecret(), decodedSecret.password.exposeSecret())
  }

  func testAutomaticStringConversion() {
    let fake = FakeCredentials(username: "Test", password: Secret("password"))
    XCTAssertEqual(
      "FakeCredentials(username: \"Test\", password: Secret([REDACTED String]))",
      "\(fake)"
    )
  }
}

private struct FakeCredentials: Codable {
  var username: String
  var password: Secret<String>
}
