// Copyright 2025–2026 Skip
import SkipUI

@frozen public struct ZStack<Content> where Content : View {
    private let alignment: Alignment
    private let content: Content

    /* @inlinable */public init(alignment: Alignment = .center, @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.content = content()
    }
}

extension ZStack : View {
    public typealias Body = Never
}

extension ZStack : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.ZStack(horizontalAlignmentKey: alignment.horizontal.key, verticalAlignmentKey: alignment.vertical.key, bridgedContent: content.Java_viewOrEmpty)
    }
}
