// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

/* @MainActor @preconcurrency */ public struct Divider : View {
    /* nonisolated */ public init() {
    }

    public typealias Body = Never
}

extension Divider : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.Divider()
    }
}
