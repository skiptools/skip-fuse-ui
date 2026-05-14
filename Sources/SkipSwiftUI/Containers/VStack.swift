// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import SkipUI

@frozen public struct VStack<Content> where Content : View {
    private let alignment: HorizontalAlignment
    private let spacing: CGFloat?
    private let content: Content

    /* @inlinable */public init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }
}

extension VStack : View {
    public typealias Body = Never
}

extension VStack : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.VStack(alignmentKey: alignment.key, spacing: spacing, bridgedContent: content.Java_viewOrEmpty)
    }
}
