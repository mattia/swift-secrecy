// MARK: - ExpressibleByUnicodeScalarLiteral

extension Secret: ExpressibleByUnicodeScalarLiteral where Wrapped == String {
  public init(unicodeScalarLiteral value: Wrapped) {
    self.init(value)
  }
}

// MARK: - ExpressibleByExtendedGraphemeClusterLiteral

extension Secret: ExpressibleByExtendedGraphemeClusterLiteral where Wrapped == String {
  public init(extendedGraphemeClusterLiteral value: Wrapped) {
    self.init(value)
  }
}

// MARK: - ExpressibleByStringLiteral

extension Secret: ExpressibleByStringLiteral where Wrapped == String {
  public init(stringLiteral value: Wrapped) {
    self.init(value)
  }
}

// MARK: - ExpressibleByIntegerLiteral

extension Secret: ExpressibleByIntegerLiteral where Wrapped == Int {
  public init(integerLiteral value: Int) {
    self.init(value)
  }
}

// MARK: - ExpressibleByFloatLiteral

extension Secret: ExpressibleByFloatLiteral where Wrapped == Double {
  public init(floatLiteral value: Double) {
    self.init(value)
  }
}

// MARK: - ExpressibleByBooleanLiteral

extension Secret: ExpressibleByBooleanLiteral where Wrapped == Bool {
  public init(booleanLiteral value: Bool) {
    self.init(value)
  }
}

// MARK: - ExpressibleByArrayLiteral

extension Secret: ExpressibleByArrayLiteral where Wrapped: _WrapperForArrayLiteralElements {
  public init(arrayLiteral elements: Wrapped.ArrayLiteralElement...) {
    self.init(Wrapped(elements))
  }
}

/// A helper protocol used to enable wrapper types to conform to `ExpressibleByArrayLiteral`.
/// Seen in https://github.com/apollographql/apollo-ios/blob/014660b14262df15f0d2c7b7e973d0a53be27b7e/Sources/ApolloAPI/GraphQLNullable.swift#L188
/// Used by ``Secret.init(arrayLiteral:)``
public protocol _WrapperForArrayLiteralElements: ExpressibleByArrayLiteral {
  init(_ array: [ArrayLiteralElement])
}
extension Array: _WrapperForArrayLiteralElements {}

// MARK: - ExpressibleByDictionaryLiteral

extension Secret: ExpressibleByDictionaryLiteral where Wrapped: _WrapperForDictionaryLiteralElements {
  public init(dictionaryLiteral elements: (Wrapped.Key, Wrapped.Value)...) {
    self.init(Wrapped(elements))
  }
}

/// A helper protocol used to enable wrapper types to conform to `ExpressibleByDictionaryLiteral`.
/// Seen in https://github.com/apollographql/apollo-ios/blob/014660b14262df15f0d2c7b7e973d0a53be27b7e/Sources/ApolloAPI/GraphQLNullable.swift#L195
/// Used by ``Secret.init(dictionaryLiteral:)``
public protocol _WrapperForDictionaryLiteralElements: ExpressibleByDictionaryLiteral {
  init(_ dictionary: [(Key, Value)])
}

extension Dictionary: _WrapperForDictionaryLiteralElements {
  public init(_ elements: [(Key, Value)]) {
    self.init(uniqueKeysWithValues: elements)
  }
}
