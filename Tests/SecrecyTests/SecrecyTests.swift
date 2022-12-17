import XCTest
import Secrecy

final class SecrecyTests: XCTestCase {
  func testReadME() {
    struct Authentication {
      var username: String
      @Secret var password: String
    }

    let container = Authentication(username: "fake", password: "abc123")
    XCTAssertEqual(
      "\(container)",
      "Authentication(username: \"fake\", _password: Secret([REDACTED String]))"
    )
  }

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
    XCTAssertEqual(credentials.password.projectedValue.value, "very_secret")
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
    XCTAssertEqual(
      secret.password.projectedValue.value,
      decodedSecret.password.projectedValue.value
    )
  }

  func testAutomaticStringConversion() {
    let fake = FakeCredentials(username: "Test", password: "password")
    XCTAssertEqual(
      "FakeCredentials(username: \"Test\", password: Secret([REDACTED String]))",
      "\(fake)"
    )
  }

  func testPropertyWrapper() {
    let propertyWrapperContainer = PropertyWrapperTest(
      username: "Test",
      password: "password"
    )

    XCTAssertEqual(
      "PropertyWrapperTest(username: \"Test\", _password: Secret([REDACTED String]))",
      "\(propertyWrapperContainer)"
    )
  }

  func testExpressibleByLiteral() {
    XCTAssertEqual(("password" as Secret<String>).debugDescription, "Secret([REDACTED String])")
    XCTAssertEqual((10 as Secret<Int>).debugDescription, "Secret([REDACTED Int])")
    XCTAssertEqual((10.0 as Secret<Double>).debugDescription, "Secret([REDACTED Double])")
    XCTAssertEqual((true as Secret<Bool>).debugDescription, "Secret([REDACTED Bool])")

    struct ArrayLiteraWrapper: CustomDebugStringConvertible {
      @Secret var value: [String]

      var debugDescription: String { _value.debugDescription }
    }
    XCTAssertEqual(
      ArrayLiteraWrapper(value: ["password", "token"]).debugDescription,
    "Secret([REDACTED Array<String>])"
    )
    struct DictionaryLiteraWrapper: CustomDebugStringConvertible {
      @Secret var value: [String: Int]

      var debugDescription: String { _value.debugDescription }
    }
    XCTAssertEqual(
      DictionaryLiteraWrapper(value: ["username": 1, "password": 2]).debugDescription,
      "Secret([REDACTED Dictionary<String, Int>])"
    )
  }

  func testValueIsNotExposed() {
    let container = PropertyWrapperTest(username: "username", password: "password")
    XCTAssertFalse(container.password.contains("password"))
    XCTAssertEqual(container.$password.value, "password")
  }

  func testCustomDebugRedactorIsUsed() {
    struct CustomRedactorWrapped {
      @Secret var password: String
    }

    let custom = Secret(
      "very_secret",
      redactor: Redactor(
        redact: { _ in "************" },
        redactForDescription: { _ in "*" },
        redactForDebug: { _ in "_" }
      )
    )

    XCTAssertEqual(custom.description, "*")
    XCTAssertEqual(custom.debugDescription, "_")
    XCTAssertEqual(custom.projectedValue.value, "very_secret")
  }
}

private struct FakeCredentials: Codable {
  var username: String
  var password: Secret<String>
}
extension String: RedactableForDecodable {
  public static var redactor: Redactor<Self> { .default }
}

private struct PropertyWrapperTest {
  var username: String
  @Secret var password: String
}
