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
    dependencies: [
        .package(name: "SnapshotTesting", url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.8.2"),
    ],
    targets: [
        .target(
            name: "Shifty",
            dependencies: []),
        .testTarget(
            name: "ShiftyTests",
            dependencies: ["Shifty", "SnapshotTesting"],
            exclude: ["testReplicantStrategy_testDebugStrategyWithLabel.1.png"],
            resources: [.copy("testReplicantStrategy_testDebugStrategyWithLabel.1.png")]),
    ]
)
