# Secrecy

`swift-secrecy` is a simple type wrapper to help you avoid accidentally exposing secrets.
This package is heavily inspired by the [`secrecy` Rust crate][rust-secrecy]

## Usage



## Codable support

Support for `Codable` is available if the wrapped type is already `Codable`. Note that this does not guarantee that the secret is not exposed (for example by encoding it to the disk in plain text) but you can always create a custom type with a dedicated `Codable` conformance.

Note that you can also create a custom type and make it only conform to `Decodable` to avoid accidental `Encodable` conformances.


## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.

[rust-secrecy]: https://github.com/iqlusioninc/crates/tree/main/secrecy
