// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "core_architecture",
    platforms: [.macOS(.v10_15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "core_architecture",
            targets: ["core_architecture"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "0.1.0"),
        .package(url: "https://github.com/SwiftGen/SwiftGen", from: "6.6.2"),
        .package(url: "https://github.com/krzysztofzablocki/Sourcery.git", "1.0.0"..<"3.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "core_architecture",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "swiftgen", package: "SwiftGen")
            ]),
        .testTarget(
            name: "core_architectureTests",
            dependencies: ["core_architecture"]),
    ]
)
