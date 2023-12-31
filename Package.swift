// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "core_architecture",
            targets: ["core_architecture"]),
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
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "0.1.0"),
        .package(url: "https://github.com/jamf/ManagedAppConfigLib", from: "1.1.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "core_architecture",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "ManagedAppConfigLib", package: "ManagedAppConfigLib")
            ]),
        .testTarget(
            name: "core_architectureTests",
            dependencies: ["core_architecture"]),
        
        
        .target(
            name: "Debugger",
            dependencies: [
                "core_architecture",
                .product(name: "Dependencies", package: "swift-dependencies")
            ]),
        .testTarget(
            name: "DebuggerTests",
            dependencies: ["Debugger"]),
        
        .target(
            name: "DebuggerUI",
            dependencies: [
                "Network",
                .product(name: "Dependencies", package: "swift-dependencies")
            ]),
        .testTarget(
            name: "DebuggerUITests",
            dependencies: ["DebuggerUI"]),

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
                .product(name: "ManagedAppConfigLib", package: "ManagedAppConfigLib")
            ]),
    ]
)
