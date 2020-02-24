// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Imperial",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "Imperial", targets: ["Imperial"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-alpha.3"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "4.0.0-alpha.1.1")
    ],
    targets: [
        .target(
            name: "Imperial",
            dependencies: [
                "Vapor",
                "JWTKit"
            ]
        ),
        .testTarget(name: "ImperialTests", dependencies: ["Imperial"]),
    ]
)
