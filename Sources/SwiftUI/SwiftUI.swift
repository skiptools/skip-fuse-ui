// Copyright 2025–2026 Skip

@_exported import SkipSwiftUI
// Prefer Skip's UI scalar when Foundation also exposes CGFloat.
@_exported import typealias SkipSwiftUI.CGFloat
// Likewise Skip's geometry types, which Foundation on Android also has. Without these, a type annotation such as
// `let p: CGPoint` is ambiguous in any file that imports Foundation alongside the facade.
@_exported import struct SkipSwiftUI.CGPoint
@_exported import struct SkipSwiftUI.CGSize
@_exported import struct SkipSwiftUI.CGRect
