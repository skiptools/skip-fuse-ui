// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "skip-fuse-ui",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9), .macCatalyst(.v16)],
    products: [
        .library(name: "SkipFuseUI", targets: ["SkipFuseUI"]),
        .library(name: "SkipSwiftUI", targets: ["SkipSwiftUI"]),
    ],
    dependencies: [ 
        .package(url: "https://source.skip.tools/skip.git", from: "1.2.21"),
        //.package(url: "https://source.skip.tools/skip-fuse.git", from: "1.0.0"),
        .package(url: "https://source.skip.tools/skip-fuse.git", branch: "no-dynamic"),
        .package(url: "https://source.skip.tools/skip-ui.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "SkipFuseUI", dependencies: ["SkipSwiftUI"]),
        .target(name: "SkipSwiftUI", dependencies: [
            .product(name: "SkipFuse", package: "skip-fuse"),
            .product(name: "SkipUI", package: "skip-ui")
        ], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "SkipSwiftUITests", dependencies: [
            "SkipSwiftUI",
            .product(name: "SkipTest", package: "skip")
        ], plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)
