// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipFuse
import SkipUI

// Native fixture views for the transpiled test target's Compose UI tests.
//
// SkipSwiftUI is a native (Skip Fuse) module, but the package's test target is transpiled,
// so tests run as Kotlin/JUnit with full access to the Compose testing APIs. The transpiled
// tests construct these fixtures through their generated bridged Kotlin facades, render them
// with `createComposeRule`, and interact through Compose semantics (clicks, size assertions)
// — exercising the complete native loop: bridged body evaluation, native `@State` storage,
// `withAnimation` provenance priming, and the SkipUI Compose rendering of the bridged tree.
//
// They live in the module itself (rather than a test-support target) because the transpiled
// test target's dependencies are folded into the `:SkipSwiftUI` gradle module, so a separate
// fixture module that itself depends on SkipSwiftUI creates a circular gradle task graph.
// They are not API: do not use these outside the test suite.

/// Test fixture: two rects driven by separate `@State` slots, one toggled inside
/// `withAnimation` and one outside, plus a plain-toggle control. Test-only.
// SKIP @bridge
public struct AnimatedSquaresTestFixture: View {
    @State var animated = false
    @State var unrelated = false

    // SKIP @bridge
    public init() {
    }

    public var body: some View {
        VStack {
            Color.red
                .frame(width: animated ? 300.0 : 100.0, height: 50.0)
                .accessibilityIdentifier("animated-rect")
            Color.green
                .frame(width: unrelated ? 300.0 : 100.0, height: 50.0)
                .accessibilityIdentifier("unrelated-rect")
            // The two-square pattern: one state toggled inside withAnimation, one outside.
            Button("animate") {
                // Qualified: `import SkipUI` (needed for the generated facade's Kotlin imports)
                // makes the unqualified `.linear(duration:)` ambiguous with SkipUI.Animation.
                withAnimation(SkipSwiftUI.Animation.linear(duration: 1.0)) {
                    animated.toggle()
                }
                unrelated.toggle()
            }
            .accessibilityIdentifier("animate-button")
            // Plain toggle with no withAnimation: the rect must snap.
            Button("snap") {
                animated.toggle()
            }
            .accessibilityIdentifier("snap-button")
        }
    }
}

/// Minimal static test fixture for smoke-testing that a bridged native view renders. Test-only.
// SKIP @bridge
public struct LabelTestFixture: View {
    // SKIP @bridge
    public init() {
    }

    public var body: some View {
        Text("native-hello")
            .accessibilityIdentifier("native-label")
    }
}
