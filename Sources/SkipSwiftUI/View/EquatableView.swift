// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipBridge
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

/// Skips reevaluating Android content while its comparison value remains equal.
///
/// Like SwiftUI's `EquatableView`, this is an update gate within the existing parent view hierarchy.
/// It does not give the subtree a new identity or lifecycle. Use
/// `androidCompositionBoundary(id:inputs:)` when the subtree needs an independently retained one.
@frozen @preconcurrency public struct AndroidEquatableView<Content, RecomposeOverride> where Content : View, RecomposeOverride : Equatable {
    public var content: Content
    public var recomposeOverride: RecomposeOverride

    /// Creates a wrapper that reuses evaluated renderables while `recomposeOverride` remains equal.
    @inlinable public init(content: Content, recomposeOverride: RecomposeOverride) {
        self.content = content
        self.recomposeOverride = recomposeOverride
    }
}

extension AndroidEquatableView : View {
    public typealias Body = Never
}

extension AndroidEquatableView : SkipUIBridging {
    /// Preserves the override's Swift `Equatable` implementation across the JVM bridge.
    internal var Java_recomposeOverride: SwiftEquatable {
        return Java_swiftEquatable(for: recomposeOverride)
    }

    public var Java_view: any SkipUI.View {
        #if os(Android)
        return SkipUI.AndroidEquatableContent(
            recomposeOverride: Java_recomposeOverride,
            bridgedContentFactory: { content.Java_viewOrEmpty }
        )
        #else
        return content.Java_viewOrEmpty
        #endif
    }
}

extension View where Self : Equatable {
    /// On Android, reuses this view's evaluated content inside the parent composition while the
    /// view value remains equal.
    nonisolated public func androidEquatable() -> AndroidEquatableView<Self, Self> {
        return AndroidEquatableView(content: self, recomposeOverride: self)
    }
}

extension View {
    /// On Android, skips reevaluating this content while `recomposeOverride` remains equal.
    ///
    /// Include every body-affecting external value in `recomposeOverride`; unchanged values skip
    /// parent-driven body evaluation for this subtree. This does not create new view identity or a
    /// separate lifecycle. Use `androidCompositionBoundary(id:inputs:)` when the subtree needs an
    /// independently retained identity and lifecycle.
    nonisolated public func androidEquatable<RecomposeOverride : Equatable>(
        recomposeOverride: RecomposeOverride
    ) -> AndroidEquatableView<Self, RecomposeOverride> {
        return AndroidEquatableView(content: self, recomposeOverride: recomposeOverride)
    }
}
