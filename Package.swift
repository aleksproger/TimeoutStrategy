// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TimeoutStrategy",
    products: [
        .library(name: "TimeoutStrategy", targets: ["TimeoutStrategy"]),
    ],
    targets: [
        .target(name: "TimeoutStrategy"),
    ]
)
