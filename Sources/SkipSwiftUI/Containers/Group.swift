// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

@frozen public struct Group<Content> {
    let content: Content

    public typealias Body = Never
}

extension Group : View where Content : View {
    /* @inlinable nonisolated */ public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
}

extension Group : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.Group(bridgedContent: (content as? any SkipUIBridging)?.Java_view ?? SkipUI.EmptyView())
    }
}
