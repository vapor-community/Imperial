// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Imperial",
    products: [
        .library(name: "Imperial", targets: ["Imperial"]),
    ],
    dependencies: [
        .package(url: "https://github.com/brokenhandsio/vapor-oauth.git", .exact("0.6.0")),
        .package(url: "https://github.com/vapor/fluent-provider.git", .exact("1.3.0"))
    ],
    targets: [
        .target(name: "Imperial", dependencies: ["VaporOAuth", "FluentProvider"]),
        .testTarget(name: "ImperialTests", dependencies: ["Imperial"]),
    ]
)
