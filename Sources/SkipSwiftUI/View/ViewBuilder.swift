// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

@resultBuilder public struct ViewBuilder {
    public static func buildBlock() -> EmptyView {
        return EmptyView()
    }

    public static func buildExpression<Content>(_ content: Content) -> Content where Content : View {
        return content
    }

    public static func buildBlock<Content>(_ content: Content) -> Content where Content : View {
        return content
    }

    public static func buildBlock(_ content: (any View)...) -> TupleView {
        return TupleView(content)
    }
}

extension ViewBuilder {
    public static func buildIf<Content>(_ content: Content?) -> Content? where Content : View {
        return content
    }

    public static func buildEither<TrueContent>(first: TrueContent) -> TrueContent where TrueContent : View {
        return first
    }

    public static func buildEither<FalseContent>(second: FalseContent) -> FalseContent where FalseContent : View {
        return second
    }
}

extension ViewBuilder {
    public static func buildLimitedAvailability<Content>(_ content: Content) -> Content where Content : View {
        return content
    }
}
