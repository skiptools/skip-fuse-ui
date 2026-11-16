// Copyright 2025–2026 Skip

public struct EmptyModifier : ViewModifier /*, BitwiseCopyable, Sendable */ {
    public static let identity = EmptyModifier()

    @inlinable nonisolated public init() {
    }

//    public typealias Body = Never
    public func body(content: Content) -> some View {
        content
    }
}
