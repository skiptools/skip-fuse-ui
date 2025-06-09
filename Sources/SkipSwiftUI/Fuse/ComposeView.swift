// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipBridge
import SkipUI

/// Embed Compose content in the SwiftUI view tree.
public struct ComposeView : View {
    private let content: UncheckedSendableBox<any JConvertible>

    /// Supply a block that returns a `SkipUI.ContentComposer`.
    nonisolated public init(content: () -> any JConvertible) {
        self.content = UncheckedSendableBox(content())
    }

    public typealias Body = Never
}

extension ComposeView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.ComposeView(bridgedContent: content.wrappedValue)
    }
}

extension View {
    /// Embed Compose modifier content.
    public func composeModifier(content: () -> any JConvertible) -> some View {
        return ComposeModifierView(target: self, content: content())
    }
}

struct ComposeModifierView<V> : View where V : View {
    private let target: UncheckedSendableBox<V>
    private let content: UncheckedSendableBox<any JConvertible>

    nonisolated init(target: V, content: any JConvertible) {
        self.target = UncheckedSendableBox(target)
        self.content = UncheckedSendableBox(content)
    }

    public typealias Body = Never
}

extension ComposeModifierView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return target.wrappedValue.Java_viewOrEmpty.applyContentModifier(bridgedContent: content.wrappedValue)
    }
}
