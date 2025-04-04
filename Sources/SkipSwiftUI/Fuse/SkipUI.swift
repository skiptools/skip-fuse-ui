// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipBridge

@_exported import class SkipUI.AppStorageSupport
@_exported import struct SkipUI.EmptyView
@_exported import class SkipUI.EnvironmentSupport
@_exported import class SkipUI.StateSupport
@_exported import protocol SkipUI.View

/// The base protocol for compiled `Views` to bridge to their corresponding `skip.ui.View` implementations.
public protocol SkipUIBridging {
    /// The composable SkipUI version of this view.
    var Java_view: any SkipUI.View { get }
}

extension View {
    /// Return the bridging view if this view is `SkipUIBridging`, else `SkipUI.EmptyView`.
    var Java_viewOrEmpty: any SkipUI.View {
        return (self as? SkipUIBridging)?.Java_view ?? SkipUI.EmptyView()
    }
}

/// Create a `SwiftHashable` that uses `Java_composeBundleString` for its string representation so that we can
/// use it to bridge arbitrary `Hashable` content but also interoperate with places where Compose requires a bundle string.
func Java_swiftHashable<T>(for value: T) -> SwiftHashable where T : Hashable {
    if let swiftHashable = value as? SwiftHashable {
        return swiftHashable
    } else {
        return SwiftHashable(value, description: { Java_composeBundleString(for: value) })
    }
}

/// - Seealso `SkipUI.composeBundleString(for:)`
func Java_composeBundleString(for value: Any?) -> String {
    if let identifiable = value as? any Identifiable {
        return String(describing: identifiable.id)
    } else if let rawRepresentable = value as? any RawRepresentable {
        return String(describing: rawRepresentable.rawValue)
    } else {
        return String(describing: value)
    }
}
