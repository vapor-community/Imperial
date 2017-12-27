// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Imperial",
    products: [
        .library(name: "Imperial", targets: ["Imperial"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .exact("2.4.0"))
    ],
    targets: [
        .target(name: "Imperial", dependencies: ["Vapor"]),
        .testTarget(name: "ImperialTests", dependencies: ["Imperial"]),
    ]
)
