// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipUI

@frozen public struct EmptyView : View {
    @inlinable nonisolated public init() {
    }

    public typealias Body = Never
}

extension EmptyView : Sendable {
}

extension EmptyView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.EmptyView()
    }
}
