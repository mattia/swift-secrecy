// MARK: - Redact

public struct Redactor<Value>: Sendable {
  public var redact: @Sendable (Value) -> Value
  public var redactForDescription: @Sendable (Value) -> String
  public var redactForDebug: @Sendable (Value) -> String

  public init(
    redact: @escaping @Sendable (Value) -> Value,
    redactForDescription: @escaping @Sendable (Value) -> String = { _ in "************" },
    redactForDebug: @escaping @Sendable (Value) -> String = { _ in
      "Secret([REDACTED \(Value.self)])"
    }
  ) {
    self.redact = redact
    self.redactForDescription = redactForDescription
    self.redactForDebug = redactForDebug
  }
}

// MARK: - Redactor<String>

public extension Redactor where Value == String {
  static let `default` = Redactor { @Sendable _ in "************" }
}

// MARK: - Redactor<Int>

public extension Redactor where Value == Int {
  static let `default` = Redactor { @Sendable _ in -1 }
}

// MARK: - Redactor<Double>

public extension Redactor where Value == Double {
  static let `default` = Redactor { @Sendable _ in -1.0 }
}

// MARK: - Redactor<Bool>

public extension Redactor where Value == Bool {
  static let `defaultTrue` = Redactor { @Sendable _ in true }
  static let `defaultFalse` = Redactor { @Sendable _ in false }
}
