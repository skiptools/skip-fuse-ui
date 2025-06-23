// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipBridge
import SkipUI

public struct TupleView {
    private let views: [any View]

    public init(_ views: [any View]) {
        self.views = views
    }
}

extension TupleView : View {
    public typealias Body = Never
}

extension TupleView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        let javaViews = views.compactMap { ($0 as? SkipUIBridging)?.Java_view }
        return SkipUI.ComposeBuilder(bridgedViews: javaViews)
    }
}
