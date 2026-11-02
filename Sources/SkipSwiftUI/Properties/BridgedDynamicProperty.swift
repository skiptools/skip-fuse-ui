// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipUI

/// A state property wrapper whose Compose storage generated bridge code syncs through the
/// wrapper itself, so it can reach one it cannot name (e.g. a `private` view property).
public protocol BridgedStateProperty<Support> : DynamicProperty {
    associatedtype Support
    func Java_initStateSupport() -> Support
    func Java_syncStateSupport(_ support: Support)
}

public func Java_bridgedProperty<P>(_ view: Any, _ label: String) -> P {
    guard let property = Mirror(reflecting: view).children.first(where: { $0.label == label })?.value as? P else {
        fatalError("\(type(of: view)) has no \(P.self) property '\(label)'")
    }
    return property
}
