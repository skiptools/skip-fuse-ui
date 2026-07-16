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
