/// A type that wraps a value which should not be exposed lightly.
@propertyWrapper
public struct Secret<Wrapped> {
  /// The value that should be treated with care.
  private let value: Wrapped
  private let redactor: Redactor<Wrapped>

  /// Creates a new secret by wrapping the provided value.
  ///
  /// - Parameter wrappedValue: The value to keep secret
  /// - Parameter redactor: The `Redactor` that masks the secret
  ///                                       
  public init(_ value: Wrapped, redactor: Redactor<Wrapped>) {
    self.value = value
    self.redactor = redactor
  }

  /// The underlying secret that we are trying to keep hidden
  public var wrappedValue: Wrapped {
    redactor.redact(value)
  }

  public var projectedValue: UnwrappedSecret<Wrapped> {
    UnwrappedSecret(value)
  }

  public struct UnwrappedSecret<Wrapped> {
    public let value: Wrapped

    public init(_ value: Wrapped) {
      self.value = value
    }
  }
}

public extension Secret {
  init(_ value: Wrapped) where Wrapped == String {
    self.value = value
    self.redactor = .default
  }

  init(_ value: Wrapped) where Wrapped == Int {
    self.value = value
    self.redactor = .default
  }

  init(_ value: Wrapped) where Wrapped == Double {
    self.value = value
    self.redactor = .default
  }

  init(_ value: Wrapped) where Wrapped == Bool {
    self.value = value
    self.redactor = .defaultFalse
  }
}

// MARK: - CustomStringConvertible

extension Secret: CustomStringConvertible {
  public var description: String {
    redactor.redactForDescription(value)
  }
}

// MARK: - CustomDebugStringConvertible

extension Secret: CustomDebugStringConvertible {
  public var debugDescription: String {
    redactor.redactForDebug(value)
  }
}

// MARK: - Sendable

extension Secret: Sendable where Wrapped: Sendable { }
