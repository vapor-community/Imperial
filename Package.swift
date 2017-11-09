// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Imperial",
    products: [
        .library(name: "Imperial", targets: ["Imperial"]),
    ],
    dependencies: [
        .package(url: "https://github.com/brokenhandsio/vapor-oauth.git", .exact("0.6.0"))
    ],
    targets: [
        .target(name: "Imperial", dependencies: ["VaporOAuth"]),
        .testTarget(name: "ImperialTests", dependencies: ["Imperial"]),
    ]
)
