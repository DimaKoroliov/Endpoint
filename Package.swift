// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Endpoint",
    platforms: [.iOS(.v9), .macOS(.v10_10), .driverKit(.v19), .macCatalyst(.v13), .tvOS(.v9), .watchOS(.v2)],
    products: [
        .library(
            name: "Endpoint",
            targets: ["Endpoint"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Endpoint",
            dependencies: []),
        .testTarget(
            name: "EndpointTests",
            dependencies: ["Endpoint"]),
    ]
)
