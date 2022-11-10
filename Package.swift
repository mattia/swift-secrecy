// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "swift-secrecy",
  products: [
    .library(
      name: "Secrecy",
      targets: ["Secrecy"]
    ),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "Secrecy",
      dependencies: []
    ),
    .testTarget(
      name: "SecrecyTests",
      dependencies: ["Secrecy"]),
  ]
)
