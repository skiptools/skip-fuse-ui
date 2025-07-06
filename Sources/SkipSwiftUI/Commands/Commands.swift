// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipFuse

@MainActor @preconcurrency public protocol Commands {
//    associatedtype Body : Commands
//
//    @CommandsBuilder @MainActor @preconcurrency var body: Self.Body { get }
}

func stubCommands() -> EmptyCommands {
    return EmptyCommands()
}

@frozen public struct EmptyCommands : Commands {
    nonisolated public init() {
    }
}

@frozen public struct AnyCommands {
    private let commands: any Commands

    public init<C>(_ commands: C) where C : Commands {
        self.commands = commands
    }
}

extension AnyCommands : Commands {
}

public struct CommandGroup<Content> : Commands where Content : View {
    @available(*, unavailable)
    nonisolated public init(before group: CommandGroupPlacement, @ViewBuilder addition: () -> Content) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init(after group: CommandGroupPlacement, @ViewBuilder addition: () -> Content) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init(replacing group: CommandGroupPlacement, @ViewBuilder addition: () -> Content) {
        fatalError()
    }

    @MainActor @preconcurrency public var body: some Commands {
        stubCommands()
    }
}

public struct CommandGroupPlacement : Sendable {
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

public struct CommandMenu<Content> : Commands where Content : View {
    @available(*, unavailable)
    nonisolated public init(_ nameKey: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public init(_ nameResource: AndroidLocalizedStringResource, @ViewBuilder content: () -> Content) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init(_ name: Text, @ViewBuilder content: () -> Content) {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public init<S>(_ name: S, @ViewBuilder content: () -> Content) where S : StringProtocol {
        fatalError()
    }

    @MainActor @preconcurrency public var body: some Commands {
        stubCommands()
    }
}

@resultBuilder public struct CommandsBuilder {
    public static func buildExpression<Content>(_ content: Content) -> Content where Content : Commands {
        return content
    }

    public static func buildIf<Content>(_ content: Content?) -> Content? where Content : Commands {
        return content
    }

    public static func buildEither<TrueContent>(first: TrueContent) -> AnyCommands where TrueContent : Commands {
        return AnyCommands(first)
    }

    public static func buildEither<FalseContent>(second: FalseContent) -> AnyCommands where FalseContent : Commands {
        return AnyCommands(second)
    }

    public static func buildLimitedAvailability<Content>(_ content: Content) -> Content where Content : Commands {
        return content
    }

    public static func buildBlock() -> EmptyCommands {
        return EmptyCommands()
    }

    public static func buildBlock<Content>(_ content: Content) -> Content where Content : Commands {
        return content
    }

    public static func buildBlock(_ content: (any Commands)...) -> TupleCommands {
        return TupleCommands(content)
    }

    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> TupleCommands where C0 : Commands, C1 : Commands {
        return TupleCommands([c0, c1])
    }

    public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> TupleCommands where C0 : Commands, C1 : Commands, C2 : Commands {
        return TupleCommands([c0, c1, c2])
    }

    public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> TupleCommands where C0 : Commands, C1 : Commands, C2 : Commands, C3 : Commands {
        return TupleCommands([c0, c1, c2, c3])
    }

    public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> TupleCommands where C0 : Commands, C1 : Commands, C2 : Commands, C3 : Commands, C4 : Commands {
        return TupleCommands([c0, c1, c2, c3, c4])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> TupleCommands where C0 : Commands, C1 : Commands, C2 : Commands, C3 : Commands, C4 : Commands, C5 : Commands {
        return TupleCommands([c0, c1, c2, c3, c4, c5])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> TupleCommands where C0 : Commands, C1 : Commands, C2 : Commands, C3 : Commands, C4 : Commands, C5 : Commands, C6 : Commands {
        return TupleCommands([c0, c1, c2, c3, c4, c5, c6])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> TupleCommands where C0 : Commands, C1 : Commands, C2 : Commands, C3 : Commands, C4 : Commands, C5 : Commands, C6 : Commands, C7 : Commands {
        return TupleCommands([c0, c1, c2, c3, c4, c5, c6, c7])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> TupleCommands where C0 : Commands, C1 : Commands, C2 : Commands, C3 : Commands, C4 : Commands, C5 : Commands, C6 : Commands, C7 : Commands, C8 : Commands {
        return TupleCommands([c0, c1, c2, c3, c4, c5, c6, c7, c8])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> TupleCommands where C0 : Commands, C1 : Commands, C2 : Commands, C3 : Commands, C4 : Commands, C5 : Commands, C6 : Commands, C7 : Commands, C8 : Commands, C9 : Commands {
        return TupleCommands([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10) -> TupleCommands where C0 : Commands, C1 : Commands, C2 : Commands, C3 : Commands, C4 : Commands, C5 : Commands, C6 : Commands, C7 : Commands, C8 : Commands, C9 : Commands, C10 : Commands {
        return TupleCommands([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11) -> TupleCommands where C0 : Commands, C1 : Commands, C2 : Commands, C3 : Commands, C4 : Commands, C5 : Commands, C6 : Commands, C7 : Commands, C8 : Commands, C9 : Commands, C10 : Commands, C11 : Commands {
        return TupleCommands([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12) -> TupleCommands where C0 : Commands, C1 : Commands, C2 : Commands, C3 : Commands, C4 : Commands, C5 : Commands, C6 : Commands, C7 : Commands, C8 : Commands, C9 : Commands, C10 : Commands, C11 : Commands, C12 : Commands {
        return TupleCommands([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13) -> TupleCommands where C0 : Commands, C1 : Commands, C2 : Commands, C3 : Commands, C4 : Commands, C5 : Commands, C6 : Commands, C7 : Commands, C8 : Commands, C9 : Commands, C10 : Commands, C11 : Commands, C12 : Commands, C13 : Commands {
        return TupleCommands([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13, _ c14: C14) -> TupleCommands where C0 : Commands, C1 : Commands, C2 : Commands, C3 : Commands, C4 : Commands, C5 : Commands, C6 : Commands, C7 : Commands, C8 : Commands, C9 : Commands, C10 : Commands, C11 : Commands, C12 : Commands, C13 : Commands, C14 : Commands {
        return TupleCommands([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13, _ c14: C14, _ c15: C15) -> TupleCommands where C0 : Commands, C1 : Commands, C2 : Commands, C3 : Commands, C4 : Commands, C5 : Commands, C6 : Commands, C7 : Commands, C8 : Commands, C9 : Commands, C10 : Commands, C11 : Commands, C12 : Commands, C13 : Commands, C14 : Commands, C15 : Commands {
        return TupleCommands([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15, C16>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13, _ c14: C14, _ c15: C15, _ c16: C16) -> TupleCommands where C0 : Commands, C1 : Commands, C2 : Commands, C3 : Commands, C4 : Commands, C5 : Commands, C6 : Commands, C7 : Commands, C8 : Commands, C9 : Commands, C10 : Commands, C11 : Commands, C12 : Commands, C13 : Commands, C14 : Commands, C15 : Commands, C16 : Commands {
        return TupleCommands([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15, C16, C17>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13, _ c14: C14, _ c15: C15, _ c16: C16, _ c17: C17) -> TupleCommands where C0 : Commands, C1 : Commands, C2 : Commands, C3 : Commands, C4 : Commands, C5 : Commands, C6 : Commands, C7 : Commands, C8 : Commands, C9 : Commands, C10 : Commands, C11 : Commands, C12 : Commands, C13 : Commands, C14 : Commands, C15 : Commands, C16 : Commands, C17 : Commands {
        return TupleCommands([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16, c17])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15, C16, C17, C18>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13, _ c14: C14, _ c15: C15, _ c16: C16, _ c17: C17, _ c18: C18) -> TupleCommands where C0 : Commands, C1 : Commands, C2 : Commands, C3 : Commands, C4 : Commands, C5 : Commands, C6 : Commands, C7 : Commands, C8 : Commands, C9 : Commands, C10 : Commands, C11 : Commands, C12 : Commands, C13 : Commands, C14 : Commands, C15 : Commands, C16 : Commands, C17 : Commands, C18 : Commands {
        return TupleCommands([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16, c17, c18])
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15, C16, C17, C18, C19>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10, _ c11: C11, _ c12: C12, _ c13: C13, _ c14: C14, _ c15: C15, _ c16: C16, _ c17: C17, _ c18: C18, _ c19: C19) -> TupleCommands where C0 : Commands, C1 : Commands, C2 : Commands, C3 : Commands, C4 : Commands, C5 : Commands, C6 : Commands, C7 : Commands, C8 : Commands, C9 : Commands, C10 : Commands, C11 : Commands, C12 : Commands, C13 : Commands, C14 : Commands, C15 : Commands, C16 : Commands, C17 : Commands, C18 : Commands, C19 : Commands {
        return TupleCommands([c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16, c17, c18, c19])
    }
}

public struct TupleCommands {
    private let commands: [any Commands]

    nonisolated public init(_ commands: [any Commands]) {
        self.commands = commands
    }
}

extension TupleCommands : Commands {
}
