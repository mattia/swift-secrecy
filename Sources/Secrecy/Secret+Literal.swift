// MARK: - ExpressibleByUnicodeScalarLiteral

extension Secret: ExpressibleByUnicodeScalarLiteral where Wrapped == String {
  public init(unicodeScalarLiteral value: Wrapped) {
    self.init(value, redactor: .default)
  }
}

// MARK: - ExpressibleByExtendedGraphemeClusterLiteral

extension Secret: ExpressibleByExtendedGraphemeClusterLiteral where Wrapped == String {
  public init(extendedGraphemeClusterLiteral value: Wrapped) {
    self.init(value, redactor: .default)
  }
}

// MARK: - ExpressibleByStringLiteral

extension Secret: ExpressibleByStringLiteral where Wrapped == String {
  public init(stringLiteral value: Wrapped) {
    self.init(value, redactor: .default)
  }
}

// MARK: - ExpressibleByIntegerLiteral

extension Secret: ExpressibleByIntegerLiteral where Wrapped == Int {
  public init(integerLiteral value: Int) {
    self.init(value, redactor: .default)
  }
}

// MARK: - ExpressibleByFloatLiteral

extension Secret: ExpressibleByFloatLiteral where Wrapped == Double {
  public init(floatLiteral value: Double) {
    self.init(value, redactor: .default)
  }
}

// MARK: - ExpressibleByBooleanLiteral

extension Secret: ExpressibleByBooleanLiteral where Wrapped == Bool {
  public init(booleanLiteral value: Bool) {
    self.init(value, redactor: .defaultFalse)
  }
}

// MARK: - ExpressibleByArrayLiteral
extension Secret: ExpressibleByArrayLiteral where Wrapped: _InitializableByArrayLiteralElements {
  public init(arrayLiteral elements: Wrapped.ArrayLiteralElement...) {
    self.init(Wrapped(elements), redactor: Redactor{ $0.anonymizeValues() })
  }
}

/// A helper protocol used to enable wrapper types to conform to `ExpressibleByArrayLiteral`.
/// Seen in https://github.com/apollographql/apollo-ios/blob/014660b14262df15f0d2c7b7e973d0a53be27b7e/Sources/ApolloAPI/GraphQLNullable.swift#L188
/// Used by ``Secret.init(arrayLiteral:)``
public protocol _InitializableByArrayLiteralElements: ExpressibleByArrayLiteral {
  init(_ array: [ArrayLiteralElement])

  var anonymizeValues: @Sendable () -> Self {  get }
}
extension Array: _InitializableByArrayLiteralElements
where Element: InitializableByLiteralType {
  public var anonymizeValues: @Sendable () -> Array<Element> {
    { @Sendable in map(Element.redactor.redact) }
  }
}

public protocol InitializableByLiteralType {
  static var redactor: Redactor<Self> { get }
}

extension String: InitializableByLiteralType {
  public static var redactor: Redactor<String> { .default }
}

extension Int: InitializableByLiteralType {
  public static var redactor: Redactor<Int> { .default }
}

extension Double: InitializableByLiteralType {
  public static var redactor: Redactor<Double> { .default }
}

// MARK: - ExpressibleByDictionaryLiteral
extension Secret: ExpressibleByDictionaryLiteral where Wrapped: _WrapperForDictionaryLiteralElements {
  public init(dictionaryLiteral elements: (Wrapped.Key, Wrapped.Value)...) {
    self.init(Wrapped(elements), redactor: Redactor { $0.anonymizeValues() })
  }
}

/// A helper protocol used to enable wrapper types to conform to `ExpressibleByDictionaryLiteral`.
/// Seen in https://github.com/apollographql/apollo-ios/blob/014660b14262df15f0d2c7b7e973d0a53be27b7e/Sources/ApolloAPI/GraphQLNullable.swift#L195
/// Used by ``Secret.init(dictionaryLiteral:)``
public protocol _WrapperForDictionaryLiteralElements: ExpressibleByDictionaryLiteral {
  init(_ dictionary: [(Key, Value)])

  var anonymizeValues: @Sendable () -> Self {  get }
}

extension Dictionary: _WrapperForDictionaryLiteralElements
where Key: InitializableByLiteralType, Value: InitializableByLiteralType {
  public init(_ elements: [(Key, Value)]) {
    self.init(uniqueKeysWithValues: elements)
  }

  public var anonymizeValues: @Sendable () -> Dictionary<Key, Value> {
    { @Sendable in
      first
        .map { (key, value) in [Key.redactor.redact(key): Value.redactor.redact(value)] }
        ?? [:]
    }
  }
}
