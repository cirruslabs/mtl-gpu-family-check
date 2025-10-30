// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "mtl-gpu-family-check",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(
            name: "mtl-gpu-family-check",
            targets: ["mtl-gpu-family-check"]
        )
    ],
    targets: [
        .executableTarget(
            name: "mtl-gpu-family-check"
        )
    ]
)
