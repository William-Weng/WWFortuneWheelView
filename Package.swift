// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWFortuneWheelView",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "WWFortuneWheelView", targets: ["WWFortuneWheelView"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "WWFortuneWheelView", dependencies: [], resources: [.process("Xib")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
