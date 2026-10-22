// swift-tools-version: 6.0
import PackageDescription

var products: [Product] = [
    .executable(name: "TaskAppCrossUI", targets: ["TaskAppCrossUI"])
]

var targets: [Target] = [
    .executableTarget(
        name: "TaskAppCrossUI",
        dependencies: [
            .product(name: "TaskAppCore", package: "Core"),
            .product(name: "SwiftCrossUI", package: "swift-cross-ui"),
            .product(name: "DefaultBackend", package: "swift-cross-ui")
        ]
    )
]

// SwiftUI is supplied by Apple and cannot be compiled on Linux.
#if os(macOS)
products.append(.executable(name: "TaskAppSwiftUI", targets: ["TaskAppSwiftUI"]))
targets.append(
    .executableTarget(
        name: "TaskAppSwiftUI",
        dependencies: [.product(name: "TaskAppCore", package: "Core")]
    )
)
#endif

let package = Package(
    name: "TaskAppDesktop",
    platforms: [.macOS(.v14)],
    products: products,
    dependencies: [
        .package(path: "../Core"),
        .package(url: "https://github.com/moreSwift/swift-cross-ui.git", exact: "0.9.0")
    ],
    targets: targets
)
