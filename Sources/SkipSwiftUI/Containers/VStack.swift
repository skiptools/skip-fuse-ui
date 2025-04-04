// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import SkipUI

/* @MainActor */ @frozen /* @preconcurrency */ public struct VStack<Content> : View where Content : View {
    private let alignment: HorizontalAlignment
    private let spacing: CGFloat?
    private let content: Content

    /* @inlinable nonisolated */ public init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }

    public typealias Body = Never
}

extension VStack : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.VStack(alignmentKey: alignment.key, spacing: spacing, bridgedContent: content.Java_viewOrEmpty)
    }
}
