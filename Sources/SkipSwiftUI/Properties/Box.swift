// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0

final class Box<Value> {
    var value: Value

    init(_ value: Value) {
        self.value = value
    }
}

//extension Box : @unchecked Sendable where Value : Sendable {
//}
