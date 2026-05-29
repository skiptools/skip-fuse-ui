// Copyright 2025-2026 Skip
// SPDX-License-Identifier: MPL-2.0

#if !os(Android) && canImport(SwiftUI)
import SwiftUI

/// A text index that can be used to create a `TextSelection` through `SkipFuseUI`.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, macCatalyst 18.0, *)
public struct TextSelectionIndex {
    let index: String.Index

    /// Creates a text selection index from a string index and its source string.
    public init(_ index: String.Index, in text: String) {
        precondition(index.samePosition(in: text.utf16) != nil, "index must have a UTF-16 position in text")
        self.index = index
    }
}

/// A text range that can be used to create a `TextSelection` through `SkipFuseUI`.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, macCatalyst 18.0, *)
public struct TextSelectionRange {
    let range: Range<String.Index>

    /// Creates a text selection range from a string index range and its source string.
    public init(_ range: Range<String.Index>, in text: String) {
        _ = TextSelectionIndex(range.lowerBound, in: text)
        _ = TextSelectionIndex(range.upperBound, in: text)
        self.range = range
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, macCatalyst 18.0, *)
public extension TextSelection {
    /// Creates a text selection from a bridge-safe text range.
    init(range: TextSelectionRange) {
        self.init(range: range.range)
    }

    /// Creates a text selection from a bridge-safe insertion point.
    init(insertionPoint: TextSelectionIndex) {
        self.init(insertionPoint: insertionPoint.index)
    }
}
#endif
