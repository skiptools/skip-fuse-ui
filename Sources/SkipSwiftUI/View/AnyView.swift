// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipUI

@frozen public struct AnyView {
    private let view: any View

    nonisolated public init<V>(_ view: V) where V : View {
        self.init(erasing: view)
    }

    nonisolated public init<V>(erasing view: V) where V : View {
        self.view = view
    }
}

extension AnyView : View {
    public typealias Body = Never
}

extension AnyView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return view.Java_viewOrEmpty
    }
}
