// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

public protocol EnvironmentKey {
    associatedtype Value

    static var defaultValue: Self.Value { get }
}
