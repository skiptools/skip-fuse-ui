// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipUI

public struct LazyHGrid<Content> where Content : View {
    private let rows: [GridItem]
    private let alignment: VerticalAlignment
    private let spacing: CGFloat?
    private let pinnedViews: PinnedScrollableViews
    private let content: Content

    nonisolated public init(rows: [GridItem], alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = .init(), @ViewBuilder content: () -> Content) {
        self.rows = rows
        self.alignment = alignment
        self.spacing = spacing
        self.pinnedViews = pinnedViews
        self.content = content()
    }
}

extension LazyHGrid : View {
    public typealias Body = Never
}

extension LazyHGrid : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        let javaRows = rows.map(\.Java_gridItem)
        return SkipUI.LazyHGrid(rows: javaRows, alignmentKey: alignment.key, spacing: spacing, bridgedPinnedViews: Int(pinnedViews.rawValue), bridgedContent: content.Java_viewOrEmpty)
    }
}
