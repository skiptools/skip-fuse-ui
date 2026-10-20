// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipUI

/// A state property wrapper whose Compose storage generated bridge code syncs through the
/// wrapper itself, so it can reach one it cannot name (e.g. a `private` view property).
public protocol BridgedStateProperty : DynamicProperty {
    func Java_initStateSupport() -> StateSupport
    func Java_syncStateSupport(_ support: StateSupport)
}

/// `BridgedStateProperty` for `@AppStorage`, whose Compose storage is an `AppStorageSupport`.
public protocol BridgedAppStorageProperty : DynamicProperty {
    func Java_initStateSupport() -> AppStorageSupport
    func Java_syncStateSupport(_ support: AppStorageSupport)
}

/// An environment property wrapper that generated bridge code syncs through the wrapper itself.
public protocol BridgedEnvironmentProperty : DynamicProperty {
    var key: String { get }
    func Java_syncEnvironmentSupport(_ support: EnvironmentSupport?)
}
