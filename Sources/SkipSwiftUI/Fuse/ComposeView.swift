// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipBridge
import SkipUI

/// Embed Compose content in the SwiftUI view tree.
public struct ComposeView : View {
    private let content: any JConvertible

    /// Supply a block that returns a `SkipUI.ContentComposer`.
    public init(content: () -> any JConvertible) {
        self.content = content()
    }

    public typealias Body = Never
}

extension ComposeView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.ComposeView(bridgedContent: content)
    }
}
