// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

@frozen public struct SafeAreaRegions : OptionSet, BitwiseCopyable, Sendable {
    public let rawValue: UInt

    @inlinable public init(rawValue: UInt) {
        self.rawValue = rawValue
    }

    public static let container = SafeAreaRegions(rawValue: 1 << 0)

    public static let keyboard = SafeAreaRegions(rawValue: 1 << 1)

    public static let all: SafeAreaRegions = [.container, .keyboard]
}

extension View {
    @available(*, unavailable)
    nonisolated public func safeAreaInset(edge: VerticalEdge, alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    nonisolated public func safeAreaInset(edge: HorizontalEdge, alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> any View) -> some View {
        return self
    }

    @available(*, unavailable)
    nonisolated public func safeAreaPadding(_ insets: EdgeInsets) -> some View {
        return self
    }

    @available(*, unavailable)
    nonisolated public func safeAreaPadding(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> some View {
        return self
    }

    @available(*, unavailable)
    nonisolated public func safeAreaPadding(_ length: CGFloat) -> some View {
        return self
    }
}
