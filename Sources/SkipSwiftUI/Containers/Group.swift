// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipUI

@frozen public struct Group<Content> {
    let content: Content

    public typealias Body = Never
}

extension Group : View where Content : View {
    /* @inlinable */ nonisolated public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
}

extension Group {
    @available(*, unavailable)
    public init<Base, Result>(subviews view: Base, @ViewBuilder transform: @escaping (Any /* SubviewsCollection */) -> Result) where /* Content == GroupElementsOfContent<Base, Result>, */ Base : View, Result : View {
        fatalError()
    }
}

extension Group {
    @available(*, unavailable)
    public init<Base, Result>(sections view: Base, @ViewBuilder transform: @escaping (Any /* SectionCollection */) -> Result) where /* Content == GroupSectionsOfContent<Base, Result>, */ Base : View, Result : View {
        fatalError()
    }
}

extension Group : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.Group(bridgedContent: (content as? any SkipUIBridging)?.Java_view ?? SkipUI.EmptyView())
    }
}
