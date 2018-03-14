// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Imperial",
    products: [
        .library(name: "Imperial", targets: ["Imperial"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0-rc")
    ],
    targets: [
        .target(name: "Imperial", dependencies: ["Vapor"]),
        .testTarget(name: "ImperialTests", dependencies: ["Imperial"]),
    ]
)
