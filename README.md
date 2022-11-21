# Secrecy

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
  var token: Secret<String>
}
```

The same type of code

```swift
let auth = Authentication(username: "fake", password: Secret("abc123"))
print(auth)
```

Will result in this log

```
Authentication(username: "fake", password: Secret([REDACTED String]))
```

Protecting you from accidental mistakes.

If you want to access the underlying value, you can do it by using the `exposeSecret` method

```swift
auth.token.exposeSecret() // This will expose the underlying `String` 
```

## Codable support

Support for `Codable` is available if the wrapped type is already `Codable`. Note that this does not guarantee that the secret is not exposed (for example by encoding it to the disk in plain text) but you can always create a custom type with a dedicated `Codable` conformance.

Note that you can also create a custom type and make it only conform to `Decodable` to avoid accidental `Encodable` conformances.


## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.

[rust-secrecy]: https://github.com/iqlusioninc/crates/tree/main/secrecy
