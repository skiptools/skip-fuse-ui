// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

#if compiler(>=6.0)
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public struct TextSelection : Equatable, Hashable {
    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    public enum Indices : Equatable, Hashable {
        case selection(Range<String.Index>)
        case multiSelection(RangeSet<String.Index>)
    }

    public var indices: TextSelection.Indices

    public var affinity: TextSelectionAffinity {
        return .automatic
    }

    public init(range: Range<String.Index>) {
        self.indices = .selection(range)
        self.isInsertion = false
    }

    public init(ranges: RangeSet<String.Index>) {
        self.indices = .multiSelection(ranges)
        self.isInsertion = false
    }

    public init(insertionPoint: String.Index) {
        self.indices = .selection(insertionPoint..<insertionPoint)
        self.isInsertion = true
    }

    public let isInsertion: Bool
}

public enum TextSelectionAffinity : Equatable, Hashable {
    case automatic
    case upstream
    case downstream
}
#endif
