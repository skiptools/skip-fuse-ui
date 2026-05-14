// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0

public protocol DynamicViewContent<Data> : View {
    associatedtype Data : Collection
    var data: Self.Data { get }
}
