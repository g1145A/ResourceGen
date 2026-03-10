// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ResourceGen",
  platforms: [
    .macOS(.v10_15),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-parsing", from: "0.14.1"),
    .package(url: "https://github.com/pointfreeco/swift-case-paths", from: "1.6.1"),
    .package(url: "https://github.com/pointfreeco/swift-tagged", from: "0.10.0"),
  ],
  targets: [
    .executableTarget(name: "ResourceGen", dependencies: [
      .product(name: "Parsing", package: "swift-parsing"),
      .product(name: "CasePaths", package: "swift-case-paths"),
      .product(name: "Tagged", package: "swift-tagged"),
    ]),
    .testTarget(name: "ResourceGenTests", dependencies: ["ResourceGen"]),
  ]
)
