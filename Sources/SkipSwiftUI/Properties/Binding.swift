// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipBridge
import SkipUI

@frozen @propertyWrapper @dynamicMemberLookup public struct Binding<Value> {
    let get: () -> Value
    let set: (Value) -> Void

    @preconcurrency public init(valueBox: BridgedStateBox<Value>? = nil, get: @escaping /* @isolated(any) @Sendable */ () -> Value, set: @escaping /* @isolated(any) @Sendable */ (Value) -> Void) {
        self.valueBox = valueBox
        self.appStorageBox = nil
        self.get = get
        self.set = set
    }

    @preconcurrency public init(appStorageBox: BridgedAppStorageBox<Value>, get: @escaping /* @isolated(any) @Sendable */ () -> Value, set: @escaping /* @isolated(any) @Sendable */ (Value) -> Void) {
        self.appStorageBox = appStorageBox
        self.valueBox = nil
        self.get = get
        self.set = set
    }

    public static func constant(_ value: Value) -> Binding<Value> {
        return Binding(get: { value }, set: { _ in })
    }

    /// The bound `@State's` bridged value box.
    ///
    /// This is exposed to generated code here rather than on the `State` because the property wrapper itself is considered
    /// private, but its projection is accessible to callers.
    public let valueBox: BridgedStateBox<Value>?

    /// The bound `@AppStorage's` bridged value box.
    ///
    /// This is exposed to generated code here rather than on the `AppStorage` because the property wrapper itself is considered
    /// private, but its projection is accessible to callers.
    public let appStorageBox: BridgedAppStorageBox<Value>?

    public var wrappedValue: Value {
        get {
            get()
        }
        nonmutating set {
            set(newValue)
        }
    }

    public var projectedValue: Binding<Value> {
        return self
    }

    public init(projectedValue: Binding<Value>) {
        self = projectedValue
    }

    public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Value, Subject>) -> Binding<Subject> {
        return Binding<Subject>(get: { wrappedValue[keyPath: keyPath] }, set: { wrappedValue[keyPath: keyPath] = $0 })
    }

//    @preconcurrency public init(get: @escaping @isolated(any) @Sendable () -> Value, set: @escaping @isolated(any) @Sendable (Value, Transaction) -> Void)

    @available(*, unavailable)
    public var transaction: Any /* Transaction */ {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }
}

extension Binding {
    public init<V>(_ base: Binding<V>) where Value == V? {
        self.init(get: { base.wrappedValue }, set: { base.wrappedValue = $0! })
    }

    public init?(_ base: Binding<Value?>) {
        guard base.wrappedValue != nil else {
            return nil
        }
        self.init(get: { base.wrappedValue! }, set: { base.wrappedValue = $0 })
    }

    public init<V>(_ base: Binding<V>) where Value == AnyHashable, V : Hashable {
        self.init(get: { AnyHashable(base.wrappedValue) }, set: { base.wrappedValue = $0.base as! V })
    }
}

extension Binding : @unchecked Sendable where Value : Sendable {
}

extension Binding : DynamicProperty {
}

extension Binding : Identifiable where Value : Identifiable {
    public var id: Value.ID {
        return wrappedValue.id
    }

    public typealias ID = Value.ID
}

extension Binding : Sequence where Value : MutableCollection {
    public typealias Element = Binding<Value.Element>
}

extension Binding : Collection where Value : MutableCollection {
    public typealias Index = Value.Index
    public typealias Indices = Value.Indices

    public var startIndex: Binding<Value>.Index {
        return wrappedValue.startIndex
    }

    public var endIndex: Binding<Value>.Index {
        return wrappedValue.endIndex
    }

    public var indices: Value.Indices {
        return wrappedValue.indices
    }

    public func index(after i: Binding<Value>.Index) -> Binding<Value>.Index {
        return wrappedValue.index(after: i)
    }

    public func formIndex(after i: inout Binding<Value>.Index) {
        wrappedValue.formIndex(after: &i)
    }

    public subscript(position: Binding<Value>.Index) -> Binding<Value>.Element {
        return Binding<Value.Element>(get: { wrappedValue[position] }, set: { wrappedValue[position] = $0 })
    }
}

extension Binding : BidirectionalCollection where Value : BidirectionalCollection, Value : MutableCollection {
    public func index(before i: Binding<Value>.Index) -> Binding<Value>.Index {
        return wrappedValue.index(before: i)
    }

    public func formIndex(before i: inout Binding<Value>.Index) {
        wrappedValue.formIndex(before: &i)
    }
}

extension Binding : RandomAccessCollection where Value : MutableCollection, Value : RandomAccessCollection {
}

extension Binding {
    @available(*, unavailable)
    public func transaction(_ transaction: Any /* Transaction */) -> Binding<Value> {
        fatalError()
    }

    @available(*, unavailable)
    public func animation(_ animation: Any? = nil /* Animation? = .default */) -> Binding<Value> {
        fatalError()
    }
}

extension Binding : JConvertible, JObjectProtocol {
    public static func fromJavaObject(_ ptr: JavaObjectPointer?, options: JConvertibleOptions) -> Self {
        let get_java: JavaObjectPointer = try! ptr!.call(method: Java_SkipUIBinding_get_methodID, options: options, args: [])
        let set_java: JavaObjectPointer = try! ptr!.call(method: Java_SkipUIBinding_set_methodID, options: options, args: [])
        let get_swift: () -> Value = SwiftClosure0.closure(forJavaObject: get_java, options: options)!
        let set_swift: (Value) -> Void = SwiftClosure1.closure(forJavaObject: set_java, options: options)!
        return Binding(get: get_swift, set: set_swift)
    }
    
    public func toJavaObject(options: JConvertibleOptions) -> JavaObjectPointer? {
        let get_java = SwiftClosure0.javaObject(for: self.get, options: options)!.toJavaParameter(options: options)
        let set_java = SwiftClosure1.javaObject(for: self.set, options: options)!.toJavaParameter(options: options)
        return try! Java_SkipUIBinding.create(ctor: Java_SkipUIBinding_constructor_methodID, options: options, args: [get_java, set_java])
    }
}

private let Java_SkipUIBinding = try! JClass(name: "skip/ui/Binding")
private let Java_SkipUIBinding_constructor_methodID = Java_SkipUIBinding.getMethodID(name: "<init>", sig: "(Lkotlin/jvm/functions/Function0;Lkotlin/jvm/functions/Function1;)V")!
private let Java_SkipUIBinding_get_methodID = Java_SkipUIBinding.getMethodID(name: "getGet", sig: "()Lkotlin/jvm/functions/Function0;")!
private let Java_SkipUIBinding_set_methodID = Java_SkipUIBinding.getMethodID(name: "getSet", sig: "()Lkotlin/jvm/functions/Function1;")!
