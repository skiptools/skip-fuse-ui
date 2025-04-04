// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

/* @MainActor @preconcurrency */ public protocol Commands {
//    associatedtype Body : Commands
//
//    @CommandsBuilder @MainActor /* @preconcurrency */ var body: Self.Body { get }
}

func stubCommands() -> EmptyCommands {
    return EmptyCommands()
}

/* @MainActor @preconcurrency */ public struct EmptyCommands : Commands {
    /* nonisolated */ public init() {
    }
}

/* @MainActor @preconcurrency */ public struct CommandGroup<Content> : Commands where Content : View {
    @available(*, unavailable)
    /* nonisolated */ public init(before group: CommandGroupPlacement, @ViewBuilder addition: () -> Content) {
        fatalError()
    }

    @available(*, unavailable)
    /* nonisolated */ public init(after group: CommandGroupPlacement, @ViewBuilder addition: () -> Content) {
        fatalError()
    }

    @available(*, unavailable)
    /* nonisolated */ public init(replacing group: CommandGroupPlacement, @ViewBuilder addition: () -> Content) {
        fatalError()
    }

    @MainActor /* @preconcurrency */ public var body: some Commands {
        stubCommands()
    }
}

public struct CommandGroupPlacement {
    public static let appInfo = CommandGroupPlacement()

    public static let appSettings = CommandGroupPlacement()

    public static let systemServices = CommandGroupPlacement()

    public static let appVisibility = CommandGroupPlacement()

    public static let appTermination = CommandGroupPlacement()

    public static let newItem = CommandGroupPlacement()

    public static let saveItem = CommandGroupPlacement()

    public static let importExport = CommandGroupPlacement()

    public static let printItem = CommandGroupPlacement()

    public static let undoRedo = CommandGroupPlacement()

    public static let pasteboard = CommandGroupPlacement()

    public static let textEditing = CommandGroupPlacement()

    public static let textFormatting = CommandGroupPlacement()

    public static let toolbar = CommandGroupPlacement()

    public static let sidebar = CommandGroupPlacement()

    public static let windowSize = CommandGroupPlacement()

    public static let windowArrangement = CommandGroupPlacement()

    public static let help = CommandGroupPlacement()
}

/* @MainActor @preconcurrency */ public struct CommandMenu<Content> : Commands where Content : View {
    @available(*, unavailable)
    /* nonisolated */ public init(_ nameKey: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        fatalError()
    }

    @available(*, unavailable)
    /* nonisolated */ public init(_ name: Text, @ViewBuilder content: () -> Content) {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload /* nonisolated */ public init<S>(_ name: S, @ViewBuilder content: () -> Content) where S : StringProtocol {
        fatalError()
    }

    @MainActor /* @preconcurrency */ public var body: some Commands {
        stubCommands()
    }
}

@resultBuilder public struct CommandsBuilder {
    public static func buildBlock() -> EmptyCommands {
        return EmptyCommands()
    }

    public static func buildExpression<Content>(_ content: Content) -> Content where Content : Commands {
        return content
    }

    public static func buildBlock<Content>(_ content: Content) -> Content where Content : Commands {
        return content
    }

    public static func buildBlock(_ content: (any Commands)...) -> TupleCommands {
        return TupleCommands(content)
    }
}

extension CommandsBuilder {
    public static func buildIf<Content>(_ content: Content?) -> Content? where Content : Commands {
        return content
    }

    public static func buildEither<TrueContent>(first: TrueContent) -> TrueContent where TrueContent : Commands {
        return first
    }

    public static func buildEither<FalseContent>(second: FalseContent) -> FalseContent where FalseContent : Commands {
        return second
    }
}

extension CommandsBuilder {
    public static func buildLimitedAvailability<Content>(_ content: Content) -> Content where Content : Commands {
        return content
    }
}

public struct TupleCommands : Commands {
    private let commands: [any Commands]

    public init(_ commands: [any Commands]) {
        self.commands = commands
    }
}
