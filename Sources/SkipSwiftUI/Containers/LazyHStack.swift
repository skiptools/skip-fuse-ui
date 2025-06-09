// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import SkipBridge
import SkipUI

@MainActor @preconcurrency public struct LazyHStack<Content> : View where Content : View {
    private let alignment: VerticalAlignment
    private let spacing: CGFloat?
    private let pinnedViews: PinnedScrollableViews
    private let content: UncheckedSendableBox<Content>

    nonisolated public init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = .init(), @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.pinnedViews = pinnedViews
        self.content = UncheckedSendableBox(content())
    }

    public typealias Body = Never
}

extension LazyHStack : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.LazyHStack(alignmentKey: alignment.key, spacing: spacing, bridgedPinnedViews: Int(pinnedViews.rawValue), bridgedContent: content.wrappedValue.Java_viewOrEmpty)
    }
}

