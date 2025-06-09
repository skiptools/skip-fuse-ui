// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipBridge
import SkipUI

@MainActor @preconcurrency public struct LazyVGrid<Content> : View where Content : View {
    private let columns: [GridItem]
    private let alignment: HorizontalAlignment
    private let spacing: CGFloat?
    private let pinnedViews: PinnedScrollableViews
    private let content: UncheckedSendableBox<Content>

    nonisolated public init(columns: [GridItem], alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = .init(), @ViewBuilder content: () -> Content) {
        self.columns = columns
        self.alignment = alignment
        self.spacing = spacing
        self.pinnedViews = pinnedViews
        self.content = UncheckedSendableBox(content())
    }

    public typealias Body = Never
}

extension LazyVGrid : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        let javaColumns = columns.map(\.Java_gridItem)
        return SkipUI.LazyVGrid(columns: javaColumns, alignmentKey: alignment.key, spacing: spacing, bridgedPinnedViews: Int(pinnedViews.rawValue), bridgedContent: content.wrappedValue.Java_viewOrEmpty)
    }
}
