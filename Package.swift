// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "Imperial",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
    ],
    products: [
        .library(name: "ImperialCore", targets: ["ImperialCore"]),
        .library(name: "ImperialAuth0", targets: ["ImperialCore", "ImperialAuth0"]),
        .library(name: "ImperialDeviantArt", targets: ["ImperialCore", "ImperialDeviantArt"]),
        .library(name: "ImperialDiscord", targets: ["ImperialCore", "ImperialDiscord"]),
        .library(name: "ImperialDropbox", targets: ["ImperialCore", "ImperialDropbox"]),
        .library(name: "ImperialFacebook", targets: ["ImperialCore", "ImperialFacebook"]),
        .library(name: "ImperialGitHub", targets: ["ImperialCore", "ImperialGitHub"]),
        .library(name: "ImperialGitlab", targets: ["ImperialCore", "ImperialGitlab"]),
        .library(name: "ImperialGoogle", targets: ["ImperialCore", "ImperialGoogle"]),
        .library(name: "ImperialImgur", targets: ["ImperialCore", "ImperialImgur"]),
        .library(name: "ImperialKeycloak", targets: ["ImperialCore", "ImperialKeycloak"]),
        .library(name: "ImperialMicrosoft", targets: ["ImperialCore", "ImperialMicrosoft"]),
        .library(name: "ImperialMixcloud", targets: ["ImperialCore", "ImperialMixcloud"]),
        .library(name: "ImperialShopify", targets: ["ImperialCore", "ImperialShopify"]),
        .library(
            name: "Imperial",
            targets: [
                "ImperialCore",
                "ImperialAuth0",
                "ImperialDeviantArt",
                "ImperialDiscord",
                "ImperialDropbox",
                "ImperialFacebook",
                "ImperialGitHub",
                "ImperialGitlab",
                "ImperialGoogle",
                "ImperialImgur",
                "ImperialKeycloak",
                "ImperialMicrosoft",
                "ImperialMixcloud",
                "ImperialShopify",
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.114.1"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "5.1.2"),
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
        .target(name: "ImperialDeviantArt", dependencies: ["ImperialCore"], swiftSettings: swiftSettings),
        .target(name: "ImperialDiscord", dependencies: ["ImperialCore"], swiftSettings: swiftSettings),
        .target(name: "ImperialDropbox", dependencies: ["ImperialCore"], swiftSettings: swiftSettings),
        .target(name: "ImperialFacebook", dependencies: ["ImperialCore"], swiftSettings: swiftSettings),
        .target(name: "ImperialGitHub", dependencies: ["ImperialCore"], swiftSettings: swiftSettings),
        .target(name: "ImperialGitlab", dependencies: ["ImperialCore"], swiftSettings: swiftSettings),
        .target(name: "ImperialGoogle", dependencies: ["ImperialCore"], swiftSettings: swiftSettings),
        .target(name: "ImperialImgur", dependencies: ["ImperialCore"], swiftSettings: swiftSettings),
        .target(name: "ImperialKeycloak", dependencies: ["ImperialCore"], swiftSettings: swiftSettings),
        .target(name: "ImperialMicrosoft", dependencies: ["ImperialCore"], swiftSettings: swiftSettings),
        .target(name: "ImperialMixcloud", dependencies: ["ImperialCore"], swiftSettings: swiftSettings),
        .target(name: "ImperialShopify", dependencies: ["ImperialCore"], swiftSettings: swiftSettings),
        .testTarget(
            name: "ImperialTests",
            dependencies: [
                .target(name: "ImperialCore"),
                .target(name: "ImperialAuth0"),
                .target(name: "ImperialDeviantArt"),
                .target(name: "ImperialDiscord"),
                .target(name: "ImperialDropbox"),
                .target(name: "ImperialFacebook"),
                .target(name: "ImperialGitHub"),
                .target(name: "ImperialGitlab"),
                .target(name: "ImperialGoogle"),
                .target(name: "ImperialImgur"),
                .target(name: "ImperialKeycloak"),
                .target(name: "ImperialMicrosoft"),
                .target(name: "ImperialMixcloud"),
                .target(name: "ImperialShopify"),
                .product(name: "VaporTesting", package: "vapor"),
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
