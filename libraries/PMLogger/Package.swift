// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PMLogger",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "PMLogger",
            targets: ["PMLogger"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", exact: "1.4.4")
    ],
    targets: [
        .target(
            name: "PMLogger",
            dependencies: [
                .product(name: "Logging", package: "swift-log")
            ],
            swiftSettings: [
              .define("APPLICATION_EXTENSION_API_ONLY=YES"),
            ]
        ),
        .testTarget(
            name: "PMLoggerTests",
            dependencies: ["PMLogger"]),
    ]
)
