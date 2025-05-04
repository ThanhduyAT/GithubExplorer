// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Authorization",
    platforms: [.iOS(
        .v17
    )],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Authorization",
            targets: ["Authorization"]
        ),
    ],
    dependencies: [
        .package(
            path: "../../Core/Networking"
        ),
        .package(
            path: "../../Core/Common"
        ),
        .package(
            url: "https://github.com/hmlongco/Factory.git",
            from: "2.3.1"
        ),
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.59.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Authorization",
            dependencies: [
                "Networking",
                "Common",
                .product(
                    name: "Factory",
                    package: "Factory"
                )
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "AuthorizationTests",
            dependencies: ["Authorization"]
        ),
    ]
)
