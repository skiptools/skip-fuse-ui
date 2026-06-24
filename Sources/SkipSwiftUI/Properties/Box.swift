// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0

final class Box<Value> {
    var value: Value

    /// The animation of the `withAnimation` scope that last wrote this box, if any. Lives on
    /// the box rather than its owning property wrapper because the box is the unit shared
    /// across bridged view re-instantiations (`Java_syncStateSupport` swaps boxes between
    /// `BridgedStateBox` instances) — a stamp on the wrapper would be lost when the body is
    /// re-evaluated on a freshly synced view value.
    var lastWriteAnimation: Animation?

    init(_ value: Value) {
        self.value = value
    }
}

//extension Box : @unchecked Sendable where Value : Sendable {
//}
