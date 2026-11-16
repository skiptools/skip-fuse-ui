// Copyright 2025–2026 Skip

@frozen public struct FillStyle : Equatable, BitwiseCopyable, Sendable {
    public var isEOFilled: Bool
    public var isAntialiased: Bool

    @inlinable public init(eoFill: Bool = false, antialiased: Bool = true) {
        self.isEOFilled = eoFill
        self.isAntialiased = antialiased
    }
}
