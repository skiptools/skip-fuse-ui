// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0

#if os(Android)
@_exported import SkipSwiftUI
#elseif canImport(SwiftUI)
@_exported import SwiftUI
@_exported import struct SkipSwiftUI.TextSelectionIndex
@_exported import struct SkipSwiftUI.TextSelectionRange

extension View where Self: Equatable {
    /// Returns this view unchanged on Apple platforms.
    ///
    /// On Android, the matching `SkipSwiftUI` API skips reevaluating the view while its value
    /// remains equal.
    nonisolated public func androidEquatable() -> some View {
        self
    }
}

extension View {
    /// Returns this view unchanged on Apple platforms.
    ///
    /// On Android, the matching `SkipSwiftUI` API skips reevaluating the view while
    /// `recomposeOverride` remains equal.
    nonisolated public func androidEquatable<RecomposeOverride: Equatable>(
        recomposeOverride: RecomposeOverride
    ) -> some View {
        self
    }

    /// Returns this view unchanged on Apple platforms.
    ///
    /// On Android, the matching `SkipSwiftUI` API gives the subtree its own retained identity and
    /// lifecycle. Keeping `id` stable preserves that host; changing `inputs` updates its content
    /// without replacing it. This no-op counterpart lets shared source call the modifier without
    /// platform conditionals.
    nonisolated public func androidCompositionBoundary(
        id: String,
        inputs: String = ""
    ) -> some View {
        self
    }
}
#endif
