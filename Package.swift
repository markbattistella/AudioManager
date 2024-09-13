// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "AudioManager",
    platforms: [
        .iOS(.v15),
        .macCatalyst(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "AudioManager",
            targets: ["AudioManager"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/markbattistella/DefaultsKit", from: "1.0.0"),
        .package(url: "https://github.com/markbattistella/SimpleLogger", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "AudioManager",
            dependencies: ["DefaultsKit", "SimpleLogger"],
            exclude: [],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        )
    ]
)
