// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "Imperial",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "ImperialCore", targets: ["ImperialCore"]),
        .library(name: "ImperialFacebook", targets: ["ImperialCore", "ImperialFacebook"]),
        .library(name: "ImperialGitHub", targets: ["ImperialCore", "ImperialGitHub"]),
        .library(name: "ImperialGitlab", targets: ["ImperialCore", "ImperialGitlab"]),
        .library(name: "ImperialGoogle", targets: ["ImperialCore", "ImperialGoogle"]),
        .library(name: "ImperialKeycloak", targets: ["ImperialCore", "ImperialKeycloak"]),
        .library(name: "ImperialShopify", targets: ["ImperialCore", "ImperialShopify"]),
        .library(name: "Imperial", targets: [
            "ImperialCore",
            "ImperialFacebook",
            "ImperialGitHub",
            "ImperialGitlab",
            "ImperialGoogle",
            "ImperialKeycloak",
            "ImperialShopify"
        ]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-rc"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "4.0.0-rc")
    ],
    targets: [
        .target(
            name: "ImperialCore",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "JWTKit", package: "jwt-kit"),
            ]
        ),
        .target(name: "ImperialFacebook", dependencies: ["ImperialCore"]),
        .target(name: "ImperialGitHub", dependencies: ["ImperialCore"]),
        .target(name: "ImperialGitlab", dependencies: ["ImperialCore"]),
        .target(name: "ImperialGoogle", dependencies: ["ImperialCore"]),
        .target(name: "ImperialKeycloak", dependencies: ["ImperialCore"]),
        .target(name: "ImperialShopify", dependencies: ["ImperialCore"]),
        .testTarget(name: "ImperialTests", dependencies: ["ImperialCore", "ImperialShopify"]),
    ]
)
