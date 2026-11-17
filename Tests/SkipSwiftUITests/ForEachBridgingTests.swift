// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest

#if !SKIP
import Foundation
@testable import SkipSwiftUI
@testable import SkipUI

/// The contract between a native `ForEach` and the SkipUI `ForEach` it bridges to.
///
/// SkipUI walks a bridged ForEach over `indexRange`, builds each row with
/// `indexedContent(index)`, tags it with `identifier(index)` (the value a Picker, TabView or List
/// selection is compared with) or, without an identifier, with the index itself, and reports
/// onDelete and onMove as offsets from the first row. These tests drive those closures the way
/// SkipUI does.
final class ForEachBridgingTests: XCTestCase {
    private func bridged<Data, ID, Content>(_ forEach: SkipSwiftUI.ForEach<Data, ID, Content>) throws -> SkipUI.ForEach {
        return try XCTUnwrap(forEach.Java_view as? SkipUI.ForEach)
    }

    private func positions(_ forEach: SkipUI.ForEach) throws -> [Int] {
        // The Int indices SkipUI walks.
        return Array(try XCTUnwrap(forEach.indexRange)())
    }

    /// The tag SkipUI gives each row of identified data: `identifier(index)`.
    private func tags(_ forEach: SkipUI.ForEach) throws -> [AnyHashable?] {
        let identifier = try XCTUnwrap(forEach.identifier)
        return try positions(forEach).map { identifier($0) }
    }

    /// The elements the native content closure receives, row by row.
    private func renderedElements<Element>(_ forEach: SkipUI.ForEach, recordedBy log: () -> [Element]) throws -> [Element] {
        let content = try XCTUnwrap(forEach.indexedContent)
        for position in try positions(forEach) {
            _ = content(position)
        }
        return log()
    }

    func testIdentifiedRangeNotStartingAtZeroSelectsAndWritesElementsInPicker() throws {
        var selection = 7
        let binding = SkipSwiftUI.Binding(get: { selection }, set: { selection = $0 })
        let forEach = SkipSwiftUI.ForEach(5..<10, id: \.self) { SkipSwiftUI.Text("\($0)") }
        let picker = SkipSwiftUI.Picker("Number", selection: binding) { forEach }
        let javaPicker = try XCTUnwrap(picker.Java_view as? SkipUI.Picker<SwiftHashable>)
        let rowTags = try tags(try bridged(forEach))

        XCTAssertEqual(rowTags, (5..<10).map { AnyHashable(Java_swiftHashable(for: $0)) })
        // The Picker shows the row whose tag equals the selection.
        var pickerSelection = javaPicker.selection
        XCTAssertEqual(rowTags.firstIndex { $0 == AnyHashable(pickerSelection.wrappedValue) }, 2)
        // Choosing a row writes its tag back through the bridged selection.
        pickerSelection.wrappedValue = try XCTUnwrap(rowTags[4]?.base as? SwiftHashable)
        XCTAssertEqual(selection, 9)
        pickerSelection.wrappedValue = try XCTUnwrap(rowTags[0]?.base as? SwiftHashable)
        XCTAssertEqual(selection, 5)
    }

    func testRangeRowIndicesAreElements() throws {
        var rendered: [Int] = []
        let forEach = try bridged(SkipSwiftUI.ForEach(5..<10) { rendered.append($0); return SkipSwiftUI.EmptyView() })
        // A Range crosses as SkipUI's own range ForEach does: each row's index is its element,
        // and SkipUI tags the row with that index.
        XCTAssertEqual(try positions(forEach), [5, 6, 7, 8, 9])
        XCTAssertNil(forEach.identifier)
        XCTAssertEqual(try renderedElements(forEach) { rendered }, [5, 6, 7, 8, 9])
    }

    func testClosedRange() throws {
        var rendered: [Int] = []
        let forEach = try bridged(SkipSwiftUI.ForEach(1...3, id: \.self) { rendered.append($0); return SkipSwiftUI.EmptyView() })
        XCTAssertEqual(try renderedElements(forEach) { rendered }, [1, 2, 3])
        XCTAssertEqual(try tags(forEach), [1, 2, 3].map { AnyHashable(Java_swiftHashable(for: $0)) })
    }

    func testEnumeratedIdentifiedByOffset() throws {
        guard #available(macOS 26, iOS 26, *) else {
            throw XCTSkip("EnumeratedSequence is a RandomAccessCollection from Swift 6.2's runtime")
        }
        var rendered: [String] = []
        let names = ["a", "b", "c"]
        let forEach = try bridged(SkipSwiftUI.ForEach(names.enumerated(), id: \.offset) { rendered.append("\($0.offset)\($0.element)"); return SkipSwiftUI.EmptyView() })
        XCTAssertEqual(try renderedElements(forEach) { rendered }, ["0a", "1b", "2c"])
        XCTAssertEqual(try tags(forEach), [0, 1, 2].map { AnyHashable(Java_swiftHashable(for: $0)) })
    }

    func testReversed() throws {
        var rendered: [String] = []
        let forEach = try bridged(SkipSwiftUI.ForEach(["a", "b", "c"].reversed(), id: \.self) { rendered.append($0); return SkipSwiftUI.EmptyView() })
        XCTAssertEqual(try renderedElements(forEach) { rendered }, ["c", "b", "a"])
        XCTAssertEqual(try tags(forEach), ["c", "b", "a"].map { AnyHashable(Java_swiftHashable(for: $0)) })
    }

    func testSliceRowsDeletesAndMovesByOffset() throws {
        let items = ["a", "b", "c", "d", "e"]
        let slice = items[2...]
        XCTAssertEqual(slice.startIndex, 2)
        var rendered: [String] = []
        var deleted: [IndexSet] = []
        var moved: [(IndexSet, Int)] = []
        let native = SkipSwiftUI.ForEach(slice, id: \.self) { rendered.append($0); return SkipSwiftUI.EmptyView() }
            .onDelete { deleted.append($0) }
            .onMove { moved.append(($0, $1)) }
        let forEach = try XCTUnwrap((native as? SkipUIBridging)?.Java_view as? SkipUI.ForEach)

        XCTAssertEqual(try positions(forEach), [0, 1, 2])
        XCTAssertEqual(try renderedElements(forEach) { rendered }, ["c", "d", "e"])
        XCTAssertEqual(try tags(forEach), ["c", "d", "e"].map { AnyHashable(Java_swiftHashable(for: $0)) })

        // SkipUI reports a row's offset from the first row, as SwiftUI does, so the action
        // receives offsets 0..<count rather than the slice's indices.
        try XCTUnwrap(forEach.onDeleteAction)(IndexSet(integer: 1))
        XCTAssertEqual(deleted, [IndexSet(integer: 1)])
        try XCTUnwrap(forEach.onMoveAction)(IndexSet(integer: 2), 0)
        XCTAssertEqual(moved.map(\.0), [IndexSet(integer: 2)])
        XCTAssertEqual(moved.map(\.1), [0])

        var remaining = Array(slice)
        remaining.remove(atOffsets: deleted[0])
        XCTAssertEqual(remaining, ["c", "e"])
    }

    func testBindingEditActionsBridgeByPosition() throws {
        struct Item: Identifiable {
            let id: Int
            var name: String
        }
        var items = [Item(id: 10, name: "x"), Item(id: 20, name: "y"), Item(id: 30, name: "z")]
        let binding = SkipSwiftUI.Binding(get: { items }, set: { items = $0 })
        var rendered: [String] = []
        let forEach = try bridged(SkipSwiftUI.ForEach(binding, editActions: .all) { (item: SkipSwiftUI.Binding<Item>) -> SkipSwiftUI.EmptyView in
            rendered.append(item.wrappedValue.name)
            return SkipSwiftUI.EmptyView()
        })
        XCTAssertEqual(try renderedElements(forEach) { rendered }, ["x", "y", "z"])
        XCTAssertEqual(try tags(forEach), [10, 20, 30].map { AnyHashable(Java_swiftHashable(for: $0)) })
        try XCTUnwrap(forEach.onDeleteAction)(IndexSet(integer: 0))
        XCTAssertEqual(items.map(\.id), [20, 30])
        try XCTUnwrap(forEach.onMoveAction)(IndexSet(integer: 1), 0)
        XCTAssertEqual(items.map(\.id), [30, 20])
    }
}
#endif
