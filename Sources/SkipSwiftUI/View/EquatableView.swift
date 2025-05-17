// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

/* @MainActor */ @frozen @preconcurrency public struct EquatableView<Content> : View where Content : Equatable, Content : View {
    /* @MainActor */ @preconcurrency public var content: Content

    @inlinable /* nonisolated */ public init(content: Content) {
        self.content = content
    }

    public typealias Body = Never
}

extension EquatableView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.EquatableView(content: content.Java_viewOrEmpty)
    }
}

extension View where Self : Equatable {
    /* @inlinable nonisolated */ public func equatable() -> EquatableView<Self> {
        return EquatableView(content: self)
    }
}
