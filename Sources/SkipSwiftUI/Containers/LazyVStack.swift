// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import SkipUI

public struct LazyVStack<Content> where Content : View {
    private let alignment: HorizontalAlignment
    private let spacing: CGFloat?
    private let pinnedViews: PinnedScrollableViews
    private let content: Content

    nonisolated public init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = .init(), @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.pinnedViews = pinnedViews
        self.content = content()
    }
}

extension LazyVStack : View {
    public typealias Body = Never
}

extension LazyVStack : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.LazyVStack(alignmentKey: alignment.key, spacing: spacing, bridgedPinnedViews: Int(pinnedViews.rawValue), bridgedContent: content.Java_viewOrEmpty)
    }
}
