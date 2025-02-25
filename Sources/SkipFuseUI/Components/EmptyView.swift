// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

public struct EmptyView : View {
    public init() {
    }

    public typealias Body = Never
}

//extension EmptyView : Sendable {
//}

extension EmptyView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.EmptyView()
    }
}
