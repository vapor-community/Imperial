// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Imperial",
    products: [
        .library(name: "Imperial", targets: ["Imperial"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/jwt.git", from: "3.0.0-rc")
    ],
    targets: [
        .target(name: "Imperial", dependencies: ["Vapor", "JWT"]),
        .testTarget(name: "ImperialTests", dependencies: ["Imperial"]),
    ]
)
