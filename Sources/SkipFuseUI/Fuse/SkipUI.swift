// Copyright 2025 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
@_exported import struct SkipUI.EmptyView
@_exported import class SkipUI.StateSupport
@_exported import protocol SkipUI.View

/// The base protocol for compiled `Views` to bridge to their corresponding `skip.ui.View` implementations.
public protocol SkipUIBridging {
    /// The composable SkipUI version of this view.
    @MainActor var Java_view: any SkipUI.View { get }
}
