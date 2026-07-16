// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipUI

@frozen @preconcurrency public struct EquatableView<Content> where Content : Equatable, Content : View {
    public var content: Content

    @inlinable public init(content: Content) {
        self.content = content
    }
}

extension EquatableView : View {
    public typealias Body = Never
}

extension EquatableView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.EquatableView(content: content.Java_viewOrEmpty)
    }
}

extension View where Self : Equatable {
    /* @inlinable */ nonisolated public func equatable() -> EquatableView<Self> {
        return EquatableView(content: self)
    }
}

/// A SkipUI-backed Android-only equatable wrapper for bridged SwiftUI content.
@frozen @preconcurrency public struct AndroidEquatableView<Content, RecomposeOverride> where Content : View, RecomposeOverride : Equatable {
    public var content: Content
    public var recomposeOverride: RecomposeOverride

    /// Creates a wrapper that skips parent-driven Android recomposition while `recomposeOverride` remains equal.
    @inlinable public init(content: Content, recomposeOverride: RecomposeOverride) {
        self.content = content
        self.recomposeOverride = recomposeOverride
    }
}

extension AndroidEquatableView : View {
    public typealias Body = Never
}

extension AndroidEquatableView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        #if os(Android)
        return SkipUI.AndroidEquatableContent(
            recomposeOverride: Java_composeBundleString(for: recomposeOverride),
            bridgedContentFactory: { content.Java_viewOrEmpty }
        )
        #else
        return content.Java_viewOrEmpty
        #endif
    }
}

extension View where Self : Equatable {
    /// On Android, reuses this view's evaluated content while the view value remains equal.
    nonisolated public func androidEquatable() -> AndroidEquatableView<Self, Self> {
        return AndroidEquatableView(content: self, recomposeOverride: self)
    }
}

extension View {
    /// On Android, reuses evaluated content until `recomposeOverride` changes.
    ///
    /// Include every body-affecting external value in `recomposeOverride`; unchanged values skip
    /// parent-driven body evaluation for this subtree.
    nonisolated public func androidEquatable<RecomposeOverride : Equatable>(
        recomposeOverride: RecomposeOverride
    ) -> AndroidEquatableView<Self, RecomposeOverride> {
        return AndroidEquatableView(content: self, recomposeOverride: recomposeOverride)
    }
}
