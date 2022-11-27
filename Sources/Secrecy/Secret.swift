/// A type that wraps a value which should not be exposed lightly.
@propertyWrapper
public struct Secret<Wrapped> {
  /// The value that should be treated with care.
  private let value: Wrapped

  /// The underlying secret that we are trying to keep hidden
  public var wrappedValue: Wrapped {
    value
  }

  /// Creates a new secret by wrapping the provided value.
  ///
  /// - Parameter value: The value to keep secret
  public init(_ value: Wrapped) {
    self.value = value
  }
}

// MARK: - CustomStringConvertible

extension Secret: CustomStringConvertible {
  public var description: String {
    "************"
  }
}

// MARK: - CustomDebugStringConvertible

extension Secret: CustomDebugStringConvertible {
  public var debugDescription: String {
    "Secret([REDACTED \(Wrapped.self)])"
  }
}

// MARK: - Sendable

extension Secret: Sendable where Wrapped: Sendable { }
