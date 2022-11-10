/// A type that wraps a value which should not be exposed lightly.
public struct Secret<Wrapped> {
  /// The value that should be treated with care.
  private let value: Wrapped

  /// Creates a new secret by wrapping the provided value.
  ///
  /// - Parameter value: The value to keep secret
  public init(_ value: Wrapped) {
    self.value = value
  }

  /// Explicitly extract the value from the secret, to be able to obtain the stored value.
  /// - Returns: The raw value of the secret.
  public func exposeSecret() -> Wrapped {
    value
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
