// Copyright 2025-2026 Skip
// SPDX-License-Identifier: MPL-2.0

#if !os(Android) && canImport(SwiftUI)
import SwiftUI

/// A text index that can be used to create a `TextSelection` across the bridge boundary.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, macCatalyst 18.0, *)
public struct TextSelectionIndex {
    let index: String.Index

    /// Creates a text selection index from a string index and its source string.
    public init(_ index: String.Index, in text: String) {
        precondition(index.samePosition(in: text.utf16) != nil, "index must have a UTF-16 position in text")
        self.index = index
    }
}

/// A text range that can be used to create a `TextSelection` across the bridge boundary.
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
#else
import SkipUI
#if SKIP_BRIDGE
import SkipBridge
#endif

/// Selection state for editable text controls.
public typealias TextSelection = SkipUI.TextSelection

/// A text index that can be used to create a `TextSelection` across the bridge boundary.
public struct TextSelectionIndex {
    #if SKIP_BRIDGE
    let utf16Offset: Int
    #else
    let index: String.Index
    #endif

    /// Creates a text selection index from a string index and its source string.
    public init(_ index: String.Index, in text: String) {
        #if SKIP_BRIDGE
        guard let utf16Index = index.samePosition(in: text.utf16) else {
            preconditionFailure("index must have a UTF-16 position in text")
        }
        self.utf16Offset = text.utf16.distance(from: text.utf16.startIndex, to: utf16Index)
        #else
        self.index = index
        #endif
    }
}

/// A text range that can be used to create a `TextSelection` across the bridge boundary.
public struct TextSelectionRange {
    #if SKIP_BRIDGE
    let utf16OffsetRange: Range<Int>
    #else
    let range: Range<String.Index>
    #endif

    /// Creates a text selection range from a string index range and its source string.
    public init(_ range: Range<String.Index>, in text: String) {
        #if SKIP_BRIDGE
        let lowerBound = TextSelectionIndex(range.lowerBound, in: text).utf16Offset
        let upperBound = TextSelectionIndex(range.upperBound, in: text).utf16Offset
        self.utf16OffsetRange = lowerBound..<upperBound
        #else
        self.range = range
        #endif
    }
}

public extension TextSelection {
    /// Creates a text selection from a bridge-safe text range.
    init(range: TextSelectionRange) {
        #if SKIP_BRIDGE
        self.init(utf16OffsetRange: range.utf16OffsetRange)
        #else
        self.init(range: range.range)
        #endif
    }

    /// Creates a text selection from a bridge-safe insertion point.
    init(insertionPoint: TextSelectionIndex) {
        #if SKIP_BRIDGE
        self.init(utf16InsertionOffset: insertionPoint.utf16Offset)
        #else
        self.init(insertionPoint: insertionPoint.index)
        #endif
    }
}

#if SKIP_BRIDGE
private extension TextSelection {
    init(utf16OffsetRange: Range<Int>) {
        let lowerBound = validatedTextSelectionOffset(utf16OffsetRange.lowerBound, name: "utf16OffsetRange.lowerBound")
        let upperBound = validatedTextSelectionOffset(utf16OffsetRange.upperBound, name: "utf16OffsetRange.upperBound")
        let endInclusive = upperBound == Int32.max ? upperBound : upperBound - 1
        let range = try! Java_KotlinIntRange.create(
            ctor: Java_KotlinIntRange_constructor_methodID,
            options: [],
            args: [
                lowerBound.toJavaParameter(options: []),
                endInclusive.toJavaParameter(options: [])
            ]
        )
        let selection = try! Java_SkipUITextSelection.create(
            ctor: Java_SkipUITextSelection_range_constructor_methodID,
            options: [],
            args: [range.toJavaParameter(options: [])]
        )
        self.init(Java_ptr: selection)
    }

    init(utf16InsertionOffset: Int) {
        let insertionOffset = validatedTextSelectionOffset(utf16InsertionOffset, name: "utf16InsertionOffset")
        let selection = try! Java_SkipUITextSelection.create(
            ctor: Java_SkipUITextSelection_insertion_constructor_methodID,
            options: [],
            args: [insertionOffset.toJavaParameter(options: [])]
        )
        self.init(Java_ptr: selection)
    }
}

private func validatedTextSelectionOffset(_ offset: Int, name: String) -> Int32 {
    precondition(offset >= 0, "\(name) must be non-negative")
    precondition(offset <= Int(Int32.max), "\(name) must fit in Int32")
    return Int32(offset)
}

private let Java_KotlinIntRange = try! JClass(name: "kotlin/ranges/IntRange")
private let Java_KotlinIntRange_constructor_methodID = Java_KotlinIntRange.getMethodID(name: "<init>", sig: "(II)V")!
private let Java_SkipUITextSelection = try! JClass(name: "skip/ui/TextSelection")
private let Java_SkipUITextSelection_range_constructor_methodID = Java_SkipUITextSelection.getMethodID(name: "<init>", sig: "(Lkotlin/ranges/IntRange;)V")!
private let Java_SkipUITextSelection_insertion_constructor_methodID = Java_SkipUITextSelection.getMethodID(name: "<init>", sig: "(I)V")!
#endif
#endif
