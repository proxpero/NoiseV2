// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "NoiseV2",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "NoiseV2",
            targets: ["NoiseV2", "Gypsum", "Math"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.9.0"),
        .package(url: "https://github.com/abertelrud/SwiftFormatPlugin.git", branch: "main"),
        .package(url: "https://github.com/google/swift-benchmark", from: "0.1.0"),
    ],
    targets: [
        .executableTarget(
            name: "Benchmarks",
            dependencies: [
                "NoiseV2",
                .product(name: "Benchmark", package: "swift-benchmark")
            ]
        ),
//        .executableTarget(
//            name: "CLI",
//            dependencies: [
//                "NoiseV2"
//            ]
//        ),
        .target(
            name: "NoiseV2",
            dependencies: ["Math"]
        ),
        .target(
            name: "Gypsum",
            dependencies: ["Math"]
        ),
        .target(
            name: "Math"
        ),
        .testTarget(
            name: "NoiseV2Tests",
            dependencies: [
                "NoiseV2",
                "Gypsum",
                "Math",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ],
            exclude: [
                "OpenSimplex2S/__Snapshots__"
            ]
        ),
    ]
)
