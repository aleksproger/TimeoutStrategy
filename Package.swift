// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "timeout-strategy",
    products: [
        .library(name: "TimeoutStrategy", targets: ["TimeoutStrategy"]),
        .library(name: "TimeoutStrategyTestKit", targets: ["TimeoutStrategyTestKit"]),
    ],
    targets: [
        .target(name: "TimeoutStrategy"),
        .target(name: "TimeoutStrategyTestKit", dependencies: ["TimeoutStrategy"]),
    ]
)
