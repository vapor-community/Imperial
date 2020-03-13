// swift-tools-version:5.2
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
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-rc"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "4.0.0-rc")
    ],
    targets: [
        .target(
            name: "Imperial",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "JWTKit", package: "jwt-kit"),
            ]
        ),
        .testTarget(name: "ImperialTests", dependencies: ["Imperial"]),
    ]
)
