// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "Networking",
            targets: ["Networking"]
        )
    ],
    targets: [
        .target(name: "Networking"),

        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking"]
        )
    ]
)
