// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipUI

public struct Divider : View {
    nonisolated public init() {
    }

    public typealias Body = Never
}

extension Divider : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.Divider()
    }
}
