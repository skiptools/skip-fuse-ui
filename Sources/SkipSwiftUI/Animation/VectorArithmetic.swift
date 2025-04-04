// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

public protocol VectorArithmetic : AdditiveArithmetic {
    mutating func scale(by rhs: Double)

    var magnitudeSquared: Double { get }
}

extension VectorArithmetic {
    @available(*, unavailable)
    public func scaled(by rhs: Double) -> Self {
        fatalError()
    }

    @available(*, unavailable)
    public mutating func interpolate(towards other: Self, amount: Double) {
        fatalError()
    }

    @available(*, unavailable)
    public func interpolated(towards other: Self, amount: Double) -> Self {
        fatalError()
    }
}
