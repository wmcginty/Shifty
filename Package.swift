// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Shifty",
    platforms: [.iOS(.v12)],
    products: [
        .library(name: "Shifty", targets: ["Shifty"]),
    ],
    targets: [
        .target(name: "Shifty", dependencies: []),
        .testTarget(name: "ShiftyTests", dependencies: ["Shifty"], path: "Tests"),
    ]
)
