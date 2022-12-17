// MARK: - Decodable

extension Secret: Decodable where Wrapped: Decodable & RedactableForDecodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let value = try container.decode(Wrapped.self)

    self = Secret(value, redactor: Wrapped.redactor)
  }
}

public protocol RedactableForDecodable {
  static var redactor: Redactor<Self> { get }
}
