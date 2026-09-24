// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest

#if !SKIP
@testable import SkipSwiftUI

final class AndroidEquatableViewTests: XCTestCase {
    private struct Model: Identifiable, Equatable {
        let id: Int
        let title: String
    }

    func testBridgedOverridePreservesEqualityBeyondIdentifiableID() {
        let original = AndroidEquatableView(
            content: EmptyView(),
            recomposeOverride: Model(id: 1, title: "A")
        )
        let equal = AndroidEquatableView(
            content: EmptyView(),
            recomposeOverride: Model(id: 1, title: "A")
        )
        let changed = AndroidEquatableView(
            content: EmptyView(),
            recomposeOverride: Model(id: 1, title: "B")
        )

        XCTAssertEqual(original.Java_recomposeOverride, equal.Java_recomposeOverride)
        XCTAssertNotEqual(original.Java_recomposeOverride, changed.Java_recomposeOverride)

        // The previous string conversion collapsed both values to the same Identifiable ID.
        XCTAssertEqual(
            Java_composeBundleString(for: original.recomposeOverride),
            Java_composeBundleString(for: changed.recomposeOverride)
        )
    }
}
#endif
