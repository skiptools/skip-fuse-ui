// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0

public protocol EnvironmentKey {
    associatedtype Value

    static var defaultValue: Self.Value { get }
}
