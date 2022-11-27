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
