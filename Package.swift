// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Shifty",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "Shifty",
            targets: ["Shifty"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Shifty",
            dependencies: []),
        .testTarget(
            name: "ShiftyTests",
            dependencies: ["Shifty"]),
    ]
)
