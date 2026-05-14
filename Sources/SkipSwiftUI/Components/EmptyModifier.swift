// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0

public struct EmptyModifier : ViewModifier /*, BitwiseCopyable, Sendable */ {
    public static let identity = EmptyModifier()

    @inlinable nonisolated public init() {
    }

//    public typealias Body = Never
    public func body(content: Content) -> some View {
        content
    }
}
