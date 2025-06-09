// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipBridge
import SkipUI

public struct TupleView : View {
    private let views: UncheckedSendableBox<[any View]>

    nonisolated public init(_ views: [any View]) {
        self.views = UncheckedSendableBox(views)
    }

    public typealias Body = Never
}

extension TupleView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        let javaViews = views.wrappedValue.compactMap { ($0 as? SkipUIBridging)?.Java_view }
        return SkipUI.ComposeBuilder(bridgedViews: javaViews)
    }
}
