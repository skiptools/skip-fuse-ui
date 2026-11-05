// Copyright 2025–2026 Skip

public protocol DynamicViewContent<Data> : View {
    associatedtype Data : Collection
    var data: Self.Data { get }
}
