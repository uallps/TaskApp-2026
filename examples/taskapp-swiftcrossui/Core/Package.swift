// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "TaskAppCore",
    products: [
        .library(name: "TaskAppCore", targets: ["TaskAppCore"]),
        .executable(name: "TaskAppParityCLI", targets: ["TaskAppParityCLI"])
    ],
    targets: [
        .target(name: "TaskAppCore"),
        .executableTarget(name: "TaskAppParityCLI", dependencies: ["TaskAppCore"]),
        .testTarget(name: "TaskAppCoreTests", dependencies: ["TaskAppCore"])
    ]
)
