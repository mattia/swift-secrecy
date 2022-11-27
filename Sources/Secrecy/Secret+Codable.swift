// MARK: - Decodable

extension Secret: Decodable where Wrapped: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let value = try container.decode(Wrapped.self)

    self = Secret(value)
  }
}

// MARK: - Encodable

extension Secret: Encodable where Wrapped: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(wrappedValue)
  }
}
