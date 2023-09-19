// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NewVersion",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "NewVersion",
            targets: ["NewVersion"]),
    ],
    targets: [
        .target(
            name: "NewVersion"
        ),
        .testTarget(
            name: "NewVersionTests",
            dependencies: ["NewVersion"]),
    ]
)
