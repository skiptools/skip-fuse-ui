// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

/* @MainActor @preconcurrency */ public struct TextEditingCommands : Commands {
    /* nonisolated */ public init() {
    }

    @MainActor /* @preconcurrency */ public var body: some Commands {
        stubCommands()
    }
}
