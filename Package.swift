// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "xliff2strings",
    platforms: [
        .macOS(SupportedPlatform.MacOSVersion.v10_13)
    ],
    products: [
        .executable(name: "xliff", targets: ["xliff"]),
        .library(name: "xliff2strings", targets: ["xliff2strings"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/MaxDesiatov/XMLCoder.git", from: "0.5.1"),
        .package(
             name: "swift-argument-parser",
             url: "https://github.com/apple/swift-argument-parser",
             .upToNextMinor(from: "0.4.3")
         ),
//        .package(url: "https://github.com/jakeheis/SwiftCLI.git", from: "5.3.0")
    ],
    targets: [
        .executableTarget(
            name: "xliff",
            dependencies: [
                "xliff2strings",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
    ),
        .target(
            name: "xliff2strings",
            dependencies: ["XMLCoder"]),
    ],
    swiftLanguageVersions: [.v5]
)
