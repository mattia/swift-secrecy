# Secrecy

[![CI](https://github.com/mattia/swift-secrecy/actions/workflows/ci.yml/badge.svg)](https://github.com/mattia/swift-secrecy/actions/workflows/ci.yml)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmattia%2Fswift-secrecy%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/mattia/swift-secrecy)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmattia%2Fswift-secrecy%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/mattia/swift-secrecy)

`swift-secrecy` is a simple type wrapper to help you avoid accidentally exposing secrets.
This package is heavily inspired by the [`secrecy` Rust crate][rust-secrecy]

## Usage

If one of your types is holding some kind of sensible information it can be easy to accidentally expose that value

For example if you are using a type to hold authentication information

```swift
struct Authentication {
  var username: String
  var token: String
}
```

maybe you later are printing debug information to identify problems

```swift
let auth = Authentication(username: "fake", password: "abc123")
print(auth)
```

Now in your log the password will be printed in cleartext

```
Authentication(username: "fake", password: "abc123")
``` 

Instead by using `Secret` you can avoid this mistakes. By changing the type definition into

```swift
struct Authentication {
  var username: String
  @Secret var password: String
}
```

The same type of code

```swift
let auth = Authentication(username: "fake", password: "abc123")
print(auth)
```

Will result in this log

```
Authentication(username: "fake", _password: Secret([REDACTED String]))
```

Protecting you from accidental mistakes.

If you want to access the underlying value, you can do it by using the `wrappedValue` property

```swift
auth.token.wrappedValue // This will expose the underlying `String` 
```

## Codable support

Support for `Encodable` is provided by the package out of the box.
To have `Decodable` support you have to provide additional information on how to redact the value. You can easily add support for your type by confirming to the `RedactableForDecodable` protocol.
For example to automatically support `Decodable` for your `Secret<String>` you can add:

```swift
extension String: RedactableForDecodable {
  public static var redactor: Redactor<Self> { .default }
}
```

Note that this does not guarantee that the secret is not exposed (for example by encoding it to the disk in plain text) but you can always create a custom type with a dedicated `Codable` conformance.


## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.

[rust-secrecy]: https://github.com/iqlusioninc/crates/tree/main/secrecy
