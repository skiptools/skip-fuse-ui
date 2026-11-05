// Copyright 2025–2026 Skip

public struct TextEditingCommands : Commands {
    nonisolated public init() {
    }

    @MainActor @preconcurrency public var body: some Commands {
        stubCommands()
    }
}
