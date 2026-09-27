// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0

#if SKIP_BRIDGE
import Foundation
import SkipUI

// Generated bridge code finds a view's state and environment properties at runtime, the way
// SwiftUI does, rather than naming each one: a name it cannot see (a `private` property, whose
// bridge lives in another file) is then no obstacle. A view type's properties are listed once
// by field reflection and cached; each is identified by its index in that list, which is
// stable because a type's field order is fixed.

#if os(Android)
// The Android Swift SDK ships the stdlib's own reflection SPI.
@_spi(Reflection) import Swift

private func forEachField(of type: Any.Type, body: (_ offset: Int, _ fieldType: Any.Type) -> Void) {
    // `_forEachField` visits nothing unless `.classType` matches whether `type` is a class. That
    // option is a stdlib `static var`, which strict concurrency won't let us read, so spell it
    // by its raw value.
    let options = type is AnyObject.Type ? _EachFieldOptions(rawValue: 1 << 0) : []
    _ = _forEachField(of: type, options: options) { _, offset, fieldType, _ in
        body(offset, fieldType)
        return true
    }
}
#else
// The host bridge build (Robolectric tests, run with `-DSKIP_BRIDGE -DROBOLECTRIC`) links
// against an Apple SDK, whose stdlib interface strips that SPI. Its runtime entry points are
// still present in libswiftCore, so reach them the way `Mirror` itself does.
private struct FieldReflectionMetadata {
    typealias NameFreeFunc = @convention(c) (UnsafePointer<CChar>?) -> Void
    var name: UnsafePointer<CChar>? = nil
    var freeFunc: NameFreeFunc? = nil
    var isStrong: Bool = true
    var isVar: Bool = false
}

@_silgen_name("swift_reflectionMirror_recursiveCount")
private func _reflectionFieldCount(_: Any.Type) -> Int

@_silgen_name("swift_reflectionMirror_recursiveChildOffset")
private func _reflectionFieldOffset(_: Any.Type, index: Int) -> Int

@_silgen_name("swift_reflectionMirror_recursiveChildMetadata")
private func _reflectionFieldType(_: Any.Type, index: Int, fieldMetadata: UnsafeMutablePointer<FieldReflectionMetadata>) -> Any.Type

private func forEachField(of type: Any.Type, body: (_ offset: Int, _ fieldType: Any.Type) -> Void) {
    for index in 0..<_reflectionFieldCount(type) {
        var metadata = FieldReflectionMetadata()
        let fieldType = _reflectionFieldType(type, index: index, fieldMetadata: &metadata)
        metadata.freeFunc?(metadata.name)
        body(_reflectionFieldOffset(type, index: index), fieldType)
    }
}
#endif

private enum DynamicPropertyAccessor {
    case state(any BridgedStateProperty.Type)
    case appStorage(any BridgedAppStorageProperty.Type)
    case environment(any BridgedEnvironmentProperty.Type)

    /// The kind code the generated Kotlin switches on.
    var code: Character {
        switch self {
        case .state: return "0"
        case .appStorage: return "1"
        case .environment: return "2"
        }
    }
}

private struct DynamicPropertyField {
    let offset: Int
    let accessor: DynamicPropertyAccessor
}

private struct DynamicPropertyDescriptor {
    let fields: [DynamicPropertyField]
    let kinds: String

    init(_ type: Any.Type) {
        var fields: [DynamicPropertyField] = []
        forEachField(of: type) { offset, fieldType in
            if let state = fieldType as? any BridgedStateProperty.Type {
                fields.append(DynamicPropertyField(offset: offset, accessor: .state(state)))
            } else if let appStorage = fieldType as? any BridgedAppStorageProperty.Type {
                fields.append(DynamicPropertyField(offset: offset, accessor: .appStorage(appStorage)))
            } else if let environment = fieldType as? any BridgedEnvironmentProperty.Type {
                fields.append(DynamicPropertyField(offset: offset, accessor: .environment(environment)))
            }
        }
        self.fields = fields
        self.kinds = String(fields.map(\.accessor.code))
    }
}

private final class DynamicPropertyDescriptors : @unchecked Sendable {
    static let shared = DynamicPropertyDescriptors()

    private let lock = NSLock()
    private var descriptors: [ObjectIdentifier: DynamicPropertyDescriptor] = [:]

    func descriptor(for type: Any.Type) -> DynamicPropertyDescriptor {
        lock.lock()
        defer { lock.unlock() }
        if let descriptor = descriptors[ObjectIdentifier(type)] {
            return descriptor
        }
        let descriptor = DynamicPropertyDescriptor(type)
        descriptors[ObjectIdentifier(type)] = descriptor
        return descriptor
    }
}

/// Calls `body` with the view's concrete type and the address of its stored properties.
///
/// A generic view's bridge peer holds the view as `Any`, so that is opened to its dynamic type.
private func withViewStorage<V, R>(_ view: V, _ body: (Any.Type, UnsafeRawPointer) -> R) -> R {
    if V.self == Any.self {
        func open<T>(_ view: T) -> R {
            return withViewStorage(view, body)
        }
        return open(unsafeBitCast(view, to: Any.self))
    }
    if V.self is AnyObject.Type {
        let object = view as AnyObject
        return withExtendedLifetime(object) {
            body(V.self, UnsafeRawPointer(Unmanaged.passUnretained(object).toOpaque()))
        }
    }
    return withUnsafeBytes(of: view) { body(V.self, $0.baseAddress!) }
}

private func withDynamicProperty<V, R>(_ view: V, _ index: Int, _ body: (DynamicPropertyAccessor, UnsafeRawPointer) -> R) -> R {
    return withViewStorage(view) { type, storage in
        let field = DynamicPropertyDescriptors.shared.descriptor(for: type).fields[index]
        return body(field.accessor, storage + field.offset)
    }
}

/// One kind code per state or environment property of the view, in index order: `0` state,
/// `1` app storage, `2` environment.
public func Java_dynamicPropertyKinds<V>(_ view: V) -> String {
    return withViewStorage(view) { type, _ in DynamicPropertyDescriptors.shared.descriptor(for: type).kinds }
}

// Each property is loaded as a copy of its wrapper; the wrappers keep their storage in shared
// boxes, so the copy syncs the view's live state.

public func Java_initDynamicState<V>(_ view: V, _ index: Int) -> StateSupport {
    return withDynamicProperty(view, index) { accessor, pointer in
        guard case .state(let type) = accessor else { fatalError("Property \(index) of \(V.self) is not state") }
        return pointer.load(as: type).Java_initStateSupport()
    }
}

public func Java_syncDynamicState<V>(_ view: V, _ index: Int, _ support: StateSupport) {
    withDynamicProperty(view, index) { accessor, pointer in
        guard case .state(let type) = accessor else { fatalError("Property \(index) of \(V.self) is not state") }
        pointer.load(as: type).Java_syncStateSupport(support)
    }
}

public func Java_initDynamicAppStorage<V>(_ view: V, _ index: Int) -> AppStorageSupport {
    return withDynamicProperty(view, index) { accessor, pointer in
        guard case .appStorage(let type) = accessor else { fatalError("Property \(index) of \(V.self) is not app storage") }
        return pointer.load(as: type).Java_initStateSupport()
    }
}

public func Java_syncDynamicAppStorage<V>(_ view: V, _ index: Int, _ support: AppStorageSupport) {
    withDynamicProperty(view, index) { accessor, pointer in
        guard case .appStorage(let type) = accessor else { fatalError("Property \(index) of \(V.self) is not app storage") }
        pointer.load(as: type).Java_syncStateSupport(support)
    }
}

public func Java_dynamicEnvironmentKey<V>(_ view: V, _ index: Int) -> String {
    return withDynamicProperty(view, index) { accessor, pointer in
        guard case .environment(let type) = accessor else { fatalError("Property \(index) of \(V.self) is not environment") }
        return pointer.load(as: type).key
    }
}

public func Java_syncDynamicEnvironment<V>(_ view: V, _ index: Int, _ support: EnvironmentSupport?) {
    withDynamicProperty(view, index) { accessor, pointer in
        guard case .environment(let type) = accessor else { fatalError("Property \(index) of \(V.self) is not environment") }
        pointer.load(as: type).Java_syncEnvironmentSupport(support)
    }
}
#endif
