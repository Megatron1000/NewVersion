// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift-tools-version:6

import PackageDescription

let package = Package(
    name: "NewVersion",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15),
    ],
    products: [
        .library(
            name: "NewVersion",
            targets: ["NewVersion"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Megatron1000/UserDefaultsActor.git", from: "0.2.0")
    ],
    targets: [
        .target(
            name: "NewVersion",
            dependencies: ["UserDefaultsActor"]
        ),
        .testTarget(
            name: "NewVersionTests",
            dependencies: ["NewVersion"]),
    ],
    swiftLanguageVersions: [.version("6.1")]
)


