// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

/* @MainActor @preconcurrency */ public struct DismissAction /* : Sendable */ {
    let action: @MainActor () -> Void

    init(action: @escaping @MainActor () -> Void) {
        self.action = action
    }

    @MainActor /* @preconcurrency */ public func callAsFunction() {
        action()
    }
}
