// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "AudioManager",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .macCatalyst(.v14),
        .tvOS(.v14),
        .visionOS(.v1),
        .watchOS(.v7)
    ],
    products: [
        .library(
            name: "AudioManager",
            targets: ["AudioManager"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/markbattistella/DefaultsKit",
            from: "1.0.0"
        )
    ],
    targets: [
        .target(
            name: "AudioManager",
            dependencies: ["DefaultsKit"],
            exclude: []
        )
    ]
)
