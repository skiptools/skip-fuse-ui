// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipSwiftUI

/// Native text used to verify truncation after crossing the Compose bridge.
public struct TruncationTestFixture: View {
    /// Creates the single-line truncation examples.
    public init() {
    }

    /// Renders overflowing titles, a fitting title, and an inherited environment value.
    public var body: some View {
        VStack {
            title("truncation-tail").truncationMode(.tail)
            title("truncation-head").truncationMode(.head)
            title("truncation-middle").truncationMode(.middle)
            VStack {
                title("truncation-inherited")
                TruncationEnvironmentLabel()
            }.environment(\.truncationMode, .middle)
            Text("Short").lineLimit(1).truncationMode(.tail)
                .frame(width: 120).accessibilityIdentifier("truncation-short")
        }
    }

    private func title(_ tag: String) -> some View {
        Text("A long media title that cannot fit within this narrow frame")
            .lineLimit(1).frame(width: 120).accessibilityIdentifier(tag)
    }
}

/// Verifies that the native environment reads the same mode Compose inherits.
struct TruncationEnvironmentLabel: View {
    @Environment(\.truncationMode) var mode

    var body: some View {
        Text(mode == .middle ? "middle" : "unexpected")
            .accessibilityIdentifier("truncation-environment")
    }
}
