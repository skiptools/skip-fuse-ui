// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import SkipUI

public struct LazyHStack<Content> where Content : View {
    private let alignment: VerticalAlignment
    private let spacing: CGFloat?
    private let pinnedViews: PinnedScrollableViews
    private let content: Content

    nonisolated public init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = .init(), @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.pinnedViews = pinnedViews
        self.content = content()
    }
}

extension LazyHStack : View {
    public typealias Body = Never
}

extension LazyHStack : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.LazyHStack(alignmentKey: alignment.key, spacing: spacing, bridgedPinnedViews: Int(pinnedViews.rawValue), bridgedContent: content.Java_viewOrEmpty)
    }
}
