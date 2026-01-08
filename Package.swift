// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "AudioManager",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .macCatalyst(.v14),
        .tvOS(.v14),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "AudioManager",
            targets: ["AudioManager"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/markbattistella/DefaultsKit", from: "26.0.0"),
        .package(url: "https://github.com/markbattistella/TriggerKit", from: "26.0.0"),
    ],
    targets: [
        .target(
            name: "AudioManager",
            dependencies: ["DefaultsKit", "TriggerKit"]
        )
    ]
)
