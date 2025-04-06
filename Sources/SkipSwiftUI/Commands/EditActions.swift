// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

public struct EditActions<Data> : OptionSet /*, Sendable */ {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    // Not included in original definition
    public static var move: EditActions<Data> {
        return EditActions<Data>(rawValue: 1) // For bridging
    }

    // Not included in original definition
    public static var delete: EditActions<Data> {
        return EditActions<Data>(rawValue: 2) // For bridging
    }

    public static var all: EditActions<Data> {
        return EditActions<Data>(rawValue: 3) // For bridging
    }
}

//extension EditActions where Data : RangeReplaceableCollection {
//    public static var delete: EditActions<Data>
//
//    public static var all: EditActions<Data>
//}
//
//extension EditActions where Data : MutableCollection {
//    public static var move: EditActions<Data>
//
//    public static var all: EditActions<Data>
//}
//
//extension EditActions where Data : MutableCollection, Data : RangeReplaceableCollection {
//    public static var all: EditActions<Data>
//}

extension RangeReplaceableCollection where Self : MutableCollection {
    public mutating func remove(atOffsets offsets: IndexSet) {
        for offset in offsets.reversed() {
            self.remove(at: self.index(self.startIndex, offsetBy: offset))
        }
    }

    // Note: This should require conformance to `MutableCollection` instead of `RangeReplaceableCollection`,
    // but the implementation would be very tricky
    public mutating func move(fromOffsets source: IndexSet, toOffset destination: Int) {
        // Calling with the same offset
        guard let firstIndex = source.first as Int?, source.count > 1 || (destination != firstIndex && destination != firstIndex + 1) else {
            return
        }

        var moved: [Element] = []
        var belowDestinationCount = 0
        for offset in source.reversed() {
            moved.append(self.remove(at: self.index(self.startIndex, offsetBy: offset)))
            if offset < destination {
                belowDestinationCount += 1
            }
        }
        for m in moved {
            self.insert(m, at: self.index(self.startIndex, offsetBy: destination - belowDestinationCount))
        }
    }
}
