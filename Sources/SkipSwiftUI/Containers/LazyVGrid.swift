// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipUI

public struct LazyVGrid<Content> where Content : View {
    private let columns: [GridItem]
    private let alignment: HorizontalAlignment
    private let spacing: CGFloat?
    private let pinnedViews: PinnedScrollableViews
    private let content: Content

    public init(columns: [GridItem], alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = .init(), @ViewBuilder content: () -> Content) {
        self.columns = columns
        self.alignment = alignment
        self.spacing = spacing
        self.pinnedViews = pinnedViews
        self.content = content()
    }
}

extension LazyVGrid : View {
    public typealias Body = Never
}

extension LazyVGrid : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        let javaColumns = columns.map(\.Java_gridItem)
        return SkipUI.LazyVGrid(columns: javaColumns, alignmentKey: alignment.key, spacing: spacing, bridgedPinnedViews: Int(pinnedViews.rawValue), bridgedContent: content.Java_viewOrEmpty)
    }
}
