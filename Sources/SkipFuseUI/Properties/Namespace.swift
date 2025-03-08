// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

@frozen @propertyWrapper public struct Namespace : DynamicProperty /*, BitwiseCopyable, Sendable */ {
    @available(*, unavailable)
    @inlinable public init() {
    }

    public var wrappedValue: Namespace.ID {
        fatalError()
    }

    @frozen public struct ID : Hashable /*, BitwiseCopyable, Sendable */ {
    }
}
