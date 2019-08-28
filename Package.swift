// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Imperial",
    products: [
        .library(name: "Imperial", targets: ["Imperial"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-alpha.3"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "4.0.0-alpha.1.1"),
    .package(url: "https://github.com/vapor/open-crypto.git", from: "4.0.0-alpha.2")
    ],
    targets: [
        .target(
            name: "Imperial",
            dependencies: [
                "Vapor",
                "JWTKit",
                "OpenCrypto"
            ]
        ),
        .testTarget(name: "ImperialTests", dependencies: ["Imperial"]),
    ]
)
