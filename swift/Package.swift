// swift-tools-version:5.9
//
// Solardemo SDK - SwiftPM manifest. The runtime itself is dependency-free
// (Foundation + the vendored Voxgig Struct port under
// Sources/ProjectNameSDK/Struct); declared feature/target deps (if any)
// appear below.
import PackageDescription

let package = Package(
    name: "SolardemoSdk",
    products: [
        .library(name: "SolardemoSdk", targets: ["SolardemoSdk"]),
    ],
    targets: [
        .target(
            name: "SolardemoSdk",
            path: "Sources/SolardemoSdk"),
        .testTarget(
            name: "SolardemoSdkTests",
            dependencies: ["SolardemoSdk"],
            path: "Tests/SolardemoSdkTests"),
    ]
)
