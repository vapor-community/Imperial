// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "Imperial",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "ImperialCore", targets: ["ImperialCore"]),
        .library(name: "ImperialAuth0", targets: ["ImperialCore", "ImperialAuth0"]),
        .library(name: "ImperialDiscord", targets: ["ImperialCore", "ImperialDiscord"]),
        .library(name: "ImperialDropbox", targets: ["ImperialCore", "ImperialDropbox"]),
        .library(name: "ImperialFacebook", targets: ["ImperialCore", "ImperialFacebook"]),
        .library(name: "ImperialGitHub", targets: ["ImperialCore", "ImperialGitHub"]),
        .library(name: "ImperialGitlab", targets: ["ImperialCore", "ImperialGitlab"]),
        .library(name: "ImperialGoogle", targets: ["ImperialCore", "ImperialGoogle"]),
        .library(name: "ImperialKeycloak", targets: ["ImperialCore", "ImperialKeycloak"]),
        .library(name: "ImperialMicrosoft", targets: ["ImperialCore", "ImperialMicrosoft"]),
        .library(name: "ImperialShopify", targets: ["ImperialCore", "ImperialShopify"]),
        .library(
            name: "Imperial",
            targets: [
                "ImperialCore",
                "ImperialAuth0",
                "ImperialDiscord",
                "ImperialDropbox",
                "ImperialFacebook",
                "ImperialGitHub",
                "ImperialGitlab",
                "ImperialGoogle",
                "ImperialKeycloak",
                "ImperialMicrosoft",
                "ImperialShopify",
            ]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "ImperialCore",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "JWTKit", package: "jwt-kit"),
            ],
            swiftSettings: swiftSettings
        ),
        .target(name: "ImperialAuth0", dependencies: ["ImperialCore"], swiftSettings: swiftSettings),
        .target(name: "ImperialDiscord", dependencies: ["ImperialCore"], swiftSettings: swiftSettings),
        .target(name: "ImperialDropbox", dependencies: ["ImperialCore"], swiftSettings: swiftSettings),
        .target(name: "ImperialFacebook", dependencies: ["ImperialCore"], swiftSettings: swiftSettings),
        .target(name: "ImperialGitHub", dependencies: ["ImperialCore"], swiftSettings: swiftSettings),
        .target(name: "ImperialGitlab", dependencies: ["ImperialCore"], swiftSettings: swiftSettings),
        .target(name: "ImperialGoogle", dependencies: ["ImperialCore"], swiftSettings: swiftSettings),
        .target(name: "ImperialKeycloak", dependencies: ["ImperialCore"], swiftSettings: swiftSettings),
        .target(name: "ImperialMicrosoft", dependencies: ["ImperialCore"], swiftSettings: swiftSettings),
        .target(name: "ImperialShopify", dependencies: ["ImperialCore"], swiftSettings: swiftSettings),
        .testTarget(
            name: "ImperialTests",
            dependencies: [
                .target(name: "ImperialCore"),
                .target(name: "ImperialAuth0"),
                .target(name: "ImperialDiscord"),
                .target(name: "ImperialDropbox"),
                .target(name: "ImperialFacebook"),
                .target(name: "ImperialGitHub"),
                .target(name: "ImperialGitlab"),
                .target(name: "ImperialGoogle"),
                .target(name: "ImperialKeycloak"),
                .target(name: "ImperialMicrosoft"),
                .target(name: "ImperialShopify"),
                .product(name: "XCTVapor", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)

var swiftSettings: [SwiftSetting] {
    [
        .enableUpcomingFeature("ExistentialAny")
    ]
}
