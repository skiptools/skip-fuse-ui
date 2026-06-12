// swift-tools-version: 6.1
import PackageDescription

let android = Context.environment["TARGET_OS_ANDROID"] ?? "0" != "0"

let package = Package(
    name: "skip-fuse-ui",
    platforms: [.iOS(.v17), .macOS(.v14), .tvOS(.v17), .watchOS(.v10), .macCatalyst(.v17)],
    products: [
        .library(name: "SkipFuseUI", type: .dynamic, targets: ["SkipFuseUI"] + (android ? ["SwiftUI"] : [])),
        .library(name: "SkipSwiftUI", type: .dynamic, targets: ["SkipSwiftUI"]),
        .library(name: "SkipSwiftUISamples", type: .dynamic, targets: ["SkipSwiftUISamples"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "1.7.4"),
        .package(url: "https://source.skip.tools/skip-fuse.git", from: "1.0.2"),
        //.package(url: "https://source.skip.tools/skip-bridge.git", "0.16.7"..<"2.0.0"),
        .package(url: "https://source.skip.tools/skip-bridge.git", branch: "transaction-propagation"), // REMOVEME
        //.package(url: "https://source.skip.tools/skip-android-bridge.git", "0.6.1"..<"2.0.0"),
        .package(url: "https://source.skip.tools/skip-android-bridge.git", branch: "transaction-propagation"), // REMOVEME
        .package(url: "https://source.skip.tools/swift-jni.git", "0.3.1"..<"2.0.0"),
        //.package(url: "https://source.skip.tools/skip-ui.git", from: "1.50.0")
        .package(url: "https://source.skip.tools/skip-ui.git", branch: "transaction-propagation") // REMOVEME
    ],
    targets: [
        .target(name: "SkipFuseUI", dependencies: ["SkipSwiftUI"]),
        .target(name: "SkipSwiftUI", dependencies: [
            .product(name: "SkipFuse", package: "skip-fuse"),
            .product(name: "SkipBridge", package: "skip-bridge"),
            .product(name: "SkipAndroidBridge", package: "skip-android-bridge"),
            .product(name: "SwiftJNI", package: "swift-jni"),
            .product(name: "SkipUI", package: "skip-ui")
        ], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "SkipSwiftUITests", dependencies: [
            "SkipSwiftUI",
            .product(name: "SkipTest", package: "skip")
        ], plugins: [.plugin(name: "skipstone", package: "skip")]),
        // Native bridged sample views used by the transpiled Compose UI tests. A separate
        // module (rather than fixtures inside SkipSwiftUI) so the test target can fold into
        // the :SkipSwiftUISamples gradle module without creating a circular task graph.
        .target(name: "SkipSwiftUISamples", dependencies: [
            "SkipSwiftUI"
        ], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "SkipSwiftUISamplesTests", dependencies: [
            "SkipSwiftUISamples",
            .product(name: "SkipBridge", package: "skip-bridge"),
            .product(name: "SkipAndroidBridge", package: "skip-android-bridge"),
            .product(name: "SkipTest", package: "skip")
        ], plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)

if android {
    package.targets += [.target(name: "SwiftUI", dependencies: ["SkipSwiftUI"])]
}

// SKIP_DEPENDENCY_ROOT overrides every skiptools dependency with a local
// `.package(path: ROOT/<repo>)` checkout, letting developers iterate against unreleased
// Skip library changes; in CI/normal builds the variable is unset and remote versions
// resolve as usual.
if let dependencyRoot = Context.environment["SKIP_DEPENDENCY_ROOT"] {
    package.dependencies = package.dependencies.map { dep in
        switch dep.kind {
        case .sourceControl(_, let location, _):
            guard let baseName = location.split(separator: "/").last?.split(separator: ".").first else {
                return dep
            }
            guard baseName.hasPrefix("skip") else {
                return dep
            }
            return Package.Dependency.package(path: dependencyRoot + "/" + baseName)
        default:
            return dep
        }
    }
    // Root-package dependencies override transitive dependencies with the same identity,
    // so also pin transitive skip libraries that this package doesn't depend on directly.
    package.dependencies.append(.package(path: dependencyRoot + "/skip-model"))
}
