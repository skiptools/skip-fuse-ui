// Copyright 2025–2026 Skip

public protocol EnvironmentKey {
    associatedtype Value

    static var defaultValue: Self.Value { get }
}
