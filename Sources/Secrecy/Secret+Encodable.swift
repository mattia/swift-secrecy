// MARK: - Encodable

extension Secret: Encodable where Wrapped: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(projectedValue.value)
  }
}
