// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
    
let package = Package(
    name: "Core",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Core",
            targets: ["Core"]),
        .library(
            name: "CoreUI",
            targets: ["CoreUI"]),
        .library(
            name: "Debugger",
            targets: ["Debugger"]),
        .library(
            name: "DebuggerUI",
            targets: ["DebuggerUI"]),
        .library(
            name: "Network",
            targets: ["Network"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "0.1.0"),
//        .package(url: "https://github.com/jamf/ManagedAppConfigLib", from: "1.1.2"),
        .package(url: "https://github.com/doordash-oss/swiftui-preview-snapshots", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
//                .product(name: "ManagedAppConfigLib", package: "ManagedAppConfigLib")
            ]),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"]),

        .target(
            name: "CoreUI",
            dependencies: [
                "Core",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "PreviewSnapshots", package: "swiftui-preview-snapshots")
            ]),
        .testTarget(
            name: "CoreUITests",
            dependencies: ["CoreUI"]),

        .target(
            name: "Debugger",
            dependencies: [
                "Core",
                .product(name: "Dependencies", package: "swift-dependencies")
            ]),
        .testTarget(
            name: "DebuggerTests",
            dependencies: ["Debugger"]),

        .target(
            name: "Network",
            dependencies: [
                "Debugger",
                .product(name: "Dependencies", package: "swift-dependencies")
            ]),
        .testTarget(
            name: "NetworkTests",
            dependencies: [
                "Network",
//                .product(name: "ManagedAppConfigLib", package: "ManagedAppConfigLib")
            ]),

        .target(
            name: "DebuggerUI",
            dependencies: [
                "Network",
                "CoreUI",
                .product(name: "Dependencies", package: "swift-dependencies")
            ]),
        .testTarget(
            name: "DebuggerUITests",
            dependencies: ["DebuggerUI"]),
    ]
)
