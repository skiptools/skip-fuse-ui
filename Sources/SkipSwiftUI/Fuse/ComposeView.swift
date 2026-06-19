// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipBridge
import SkipUI

/// Embed Compose content in the SwiftUI view tree.
public struct ComposeView {
    private let content: any JConvertible

    /// Supply a block that returns a `SkipUI.ContentComposer`.
    public init(content: () -> any JConvertible) {
        self.content = content()
    }
}

extension ComposeView : View {
    public typealias Body = Never
}

extension ComposeView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.ComposeView(bridgedContent: content)
    }
}

extension View {
    /// Embed Compose modifier content.
    nonisolated public func composeModifier(content: () -> any JConvertible) -> some View {
        return ComposeModifierView(target: self, content: content())
    }

    /// Moves a view with a Compose graphics-layer translation on Android.
    ///
    /// Hit testing keeps the original layout bounds, so this is intended for controlled
    /// overlay surfaces whose frame is already fixed.
    nonisolated public func graphicsLayerOffset(x: CGFloat = 0.0, y: CGFloat = 0.0) -> some View {
        return GraphicsLayerOffsetView(target: self, x: x, y: y)
    }
}

struct ComposeModifierView<V> where V : View {
    private let target: V
    private let content: any JConvertible

    nonisolated init(target: V, content: any JConvertible) {
        self.target = target
        self.content = content
    }
}

extension ComposeModifierView : View {
    public typealias Body = Never
}

extension ComposeModifierView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return target.Java_viewOrEmpty.applyContentModifier(bridgedContent: content)
    }
}

struct GraphicsLayerOffsetView<V> where V : View {
    private let target: V
    private let x: CGFloat
    private let y: CGFloat

    nonisolated init(target: V, x: CGFloat, y: CGFloat) {
        self.target = target
        self.x = x
        self.y = y
    }
}

extension GraphicsLayerOffsetView : View {
    public typealias Body = Never
}

extension GraphicsLayerOffsetView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        #if os(Android)
        return target.Java_viewOrEmpty.graphicsLayerOffset(x: x, y: y)
        #else
        return target.Java_viewOrEmpty
        #endif
    }
}
