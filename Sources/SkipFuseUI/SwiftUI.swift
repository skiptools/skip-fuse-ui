// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0

#if os(Android)
@_exported import SkipSwiftUI
#elseif canImport(SwiftUI)
@_exported import SwiftUI
@_exported import struct SkipSwiftUI.TextSelectionIndex
@_exported import struct SkipSwiftUI.TextSelectionRange
#endif
