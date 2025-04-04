// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

final class Box<Value> {
    var value: Value

    init(_ value: Value) {
        self.value = value
    }
}

//extension Box : @unchecked Sendable where Value : Sendable {
//}
