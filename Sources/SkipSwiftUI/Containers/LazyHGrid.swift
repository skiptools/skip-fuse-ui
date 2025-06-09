// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipBridge
import SkipUI

@MainActor @preconcurrency public struct LazyHGrid<Content> : View where Content : View {
    private let rows: [GridItem]
    private let alignment: VerticalAlignment
    private let spacing: CGFloat?
    private let pinnedViews: PinnedScrollableViews
    private let content: UncheckedSendableBox<Content>

    nonisolated public init(rows: [GridItem], alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = .init(), @ViewBuilder content: () -> Content) {
        self.rows = rows
        self.alignment = alignment
        self.spacing = spacing
        self.pinnedViews = pinnedViews
        self.content = UncheckedSendableBox(content())
    }

    public typealias Body = Never
}

extension LazyHGrid : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        let javaRows = rows.map(\.Java_gridItem)
        return SkipUI.LazyHGrid(rows: javaRows, alignmentKey: alignment.key, spacing: spacing, bridgedPinnedViews: Int(pinnedViews.rawValue), bridgedContent: content.wrappedValue.Java_viewOrEmpty)
    }
}
