// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

public protocol DynamicViewContent : View {
    associatedtype Data : Collection
    var data: Self.Data { get }
}
