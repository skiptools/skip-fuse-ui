// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipFuse
import SkipSwiftUI

/// Sample: a segmented Picker over a range starting at 5, identified by its elements and with
/// no explicit tags, so each row's tag is its element.
public struct ForEachRangePickerTestFixture: View {
    @State var selection = 7

    public init() {
    }

    public var body: some View {
        VStack {
            Picker("Number", selection: $selection) {
                ForEach(5..<10, id: \.self) { number in
                    Text("n\(number)")
                }
            }
            .pickerStyle(.segmented)
            Text("selection: \(selection)")
                .accessibilityIdentifier("range-picker-selection")
        }
    }
}

/// Sample: a menu Picker over a range starting at 1; its collapsed label shows the selected row.
public struct ForEachRangeMenuPickerTestFixture: View {
    @State var selection = 3

    public init() {
    }

    public var body: some View {
        VStack {
            Picker("Count", selection: $selection) {
                ForEach(1..<11, id: \.self) { number in
                    Text("count \(number)")
                }
            }
            .pickerStyle(.menu)
            Text("selection: \(selection)")
                .accessibilityIdentifier("range-menu-picker-selection")
        }
    }
}

/// Sample: ForEach over data whose index is not an `Int` counted from zero.
public struct ForEachCollectionsTestFixture: View {
    let names = ["a", "b", "c", "d", "e"]

    public init() {
    }

    public var body: some View {
        VStack {
            ForEach(5..<7) { number in
                Text("range \(number)")
            }
            ForEach(1...3, id: \.self) { number in
                Text("closed \(number)")
            }
            ForEach(names.reversed(), id: \.self) { name in
                Text("reversed \(name)")
            }
            ForEach(names[3...], id: \.self) { name in
                Text("slice \(name)")
            }
            #if os(Android)
            ForEach(names.enumerated(), id: \.offset) { pair in
                Text("pair \(pair.offset) \(pair.element)")
            }
            #endif
        }
    }
}

/// Sample: two sibling `ForEach` ranges over the same numbers in one List, whose rows must not
/// share lazy item keys.
public struct ForEachSiblingRangesTestFixture: View {
    public init() {
    }

    public var body: some View {
        List {
            ForEach(0..<2) { number in
                Text("first \(number)")
            }
            ForEach(0..<2) { number in
                Text("second \(number)")
            }
        }
    }
}

/// Sample: a List over a slice that starts at index 2, whose onDelete records the offsets it
/// receives.
public struct ForEachSliceDeleteTestFixture: View {
    @State var items = ["a", "b", "c", "d", "e"]
    @State var deleted = "none"

    public init() {
    }

    public var body: some View {
        VStack {
            Text("deleted: \(deleted)")
                .accessibilityIdentifier("slice-delete-log")
            List {
                ForEach(items[2...], id: \.self) { item in
                    Text("row \(item)")
                }
                .onDelete { offsets in
                    deleted = offsets.map { String($0) }.joined(separator: ",")
                    let slice = items[2...]
                    items.remove(atOffsets: IndexSet(offsets.map { slice.startIndex + $0 }))
                }
            }
        }
    }
}
