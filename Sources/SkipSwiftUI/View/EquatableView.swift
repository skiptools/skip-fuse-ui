// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipUI

@frozen @preconcurrency public struct EquatableView<Content> where Content : Equatable, Content : View {
    public var content: Content

    @inlinable public init(content: Content) {
        self.content = content
    }
}

extension EquatableView : View {
    public typealias Body = Never
}

extension EquatableView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.EquatableView(content: content.Java_viewOrEmpty)
    }
}

extension View where Self : Equatable {
    /* @inlinable */ nonisolated public func equatable() -> EquatableView<Self> {
        return EquatableView(content: self)
    }
}
