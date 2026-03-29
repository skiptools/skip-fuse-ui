// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0

public struct TextEditingCommands : Commands {
    nonisolated public init() {
    }

    @MainActor @preconcurrency public var body: some Commands {
        stubCommands()
    }
}
