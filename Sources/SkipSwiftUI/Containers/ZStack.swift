// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

/* @MainActor */ @frozen /* @preconcurrency */ public struct ZStack<Content> : View where Content : View {
    private let alignment: Alignment
    private let content: Content

    /* @inlinable nonisolated */ public init(alignment: Alignment = .center, @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.content = content()
    }

    public typealias Body = Never
}

extension ZStack : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.ZStack(horizontalAlignmentKey: alignment.horizontal.key, verticalAlignmentKey: alignment.vertical.key, bridgedContent: content.Java_viewOrEmpty)
    }
}
