// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !ROBOLECTRIC && canImport(CoreGraphics)
import CoreGraphics
#endif
import Foundation
import SkipBridge
import SkipUI

public struct EnvironmentValues : CustomStringConvertible {
    public init() {
    }

    public subscript<K>(key: K.Type) -> K.Value where K : EnvironmentKey {
        get { key.defaultValue } // We rely on our implementation to always return the default value
        set { fatalError("Set via .environment(_:_:) View modifier") }
    }

    public var description: String {
        return "EnvironmentValues (Bridged)"
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension EnvironmentValues {
    public subscript<T>(objectType: T.Type) -> T? where T : AnyObject, T : Observable {
        get { nil }  // We rely on our implementation to always return the default value
        set { fatalError("Set via .environment(_:) View modifier") }
    }
}

extension EnvironmentValues {
    static var shared = EnvironmentValues()

    /// Return a bridgable key to use for the given key path value.
    static func key<Value>(for keyPath: KeyPath<EnvironmentValues, Value>) -> String {
        return key(forAny: keyPath)
    }

    /// Return a bridgable key to use for the given observable value.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    static func key<T>(for type: T.Type) -> String where T: Observable {
        return key(forAny: String(describing: type))
    }

    /// Convert a builtin environment value from Compose.
    static func builtin(key: String, bridgedValue: Any?) -> Any? {
        // NOTE: We also maintain equivalent code in SkipUI.EnvironmentValues.
        // It would be nice to come up with a better way to do this...
        switch key {
        case "colorScheme":
            return ColorScheme(rawValue: bridgedValue as! Int)
        case "dismiss":
            return DismissAction(action: (bridgedValue as! SkipUI.DismissAction).action)
        default:
            return nil
        }
    }

    private static var keys: [AnyHashable: String] = {
        var keys: [AnyHashable: String] = [:]
        // Initialize builtins
        keys[\EnvironmentValues.colorScheme] = "colorScheme"
        keys[\EnvironmentValues.dismiss] = "dismiss"
        return keys
    }()

    private static func key(forAny hashable: AnyHashable) -> String {
        if let key = keys[hashable] {
            return key
        }
        let key = nextKey
        keys[hashable] = key
        return key
    }

    private static var nextKey: String {
        _nextKey += 1
        return "userkey:\(String(describing: _nextKey))"
    }
    private static var _nextKey = 0
}

extension View {
    /* nonisolated */ public func environment<V>(_ keyPath: WritableKeyPath<EnvironmentValues, V>, _ value: V) -> some View {
        return ModifierView(target: self) {
            let key = EnvironmentValues.key(for: keyPath)
            guard key.hasPrefix("userkey:") else {
                fatalError("Set via .\(key) View modifier")
            }
            let view = $0.Java_viewOrEmpty
            let ptr = SwiftObjectPointer.pointer(to: Box(value), retain: true)
            let value = EnvironmentSupport(valueHolder: ptr)
            return view.environment(bridgedKey: key, value: value)
        }
    }

    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    /* nonisolated */ public func environment<T>(_ object: T?) -> some View where T : AnyObject, T : Observable {
        return ModifierView(target: self) {
            let view = $0.Java_viewOrEmpty
            let key = EnvironmentValues.key(for: T.self)
            if let object {
                let ptr = SwiftObjectPointer.pointer(to: Box(object), retain: true)
                let value = EnvironmentSupport(valueHolder: ptr)
                return view.environment(bridgedKey: key, value: value)
            } else {
                return view.environment(bridgedKey: key, value: nil)
            }
        }
    }
}

// TODO: Bridge supported keys to SkipUI

extension EnvironmentValues {
    @available(*, unavailable)
    public var layoutDirection: Any /* LayoutDirection */ {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var isEnabled: Bool {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var openURL: Any /* OpenURLAction */ {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var isLuminanceReduced: Bool {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var redactionReasons: Any /* RedactionReasons */ {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var controlSize: Any /* ControlSize */ {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var backgroundMaterial: Any? /* Material? */ {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var materialActiveAppearance: Any /* MaterialActiveAppearance */ {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var symbolRenderingMode: Any? /* SymbolRenderingMode? */ {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var multilineTextAlignment: Any /* TextAlignment */ {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }

    @available(*, unavailable)
    public var truncationMode: Any /* Text.TruncationMode */ {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }

    @available(*, unavailable)
    public var lineSpacing: CGFloat {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }

    @available(*, unavailable)
    public var allowsTightening: Bool {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }

    @available(*, unavailable)
    public var minimumScaleFactor: CGFloat {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }

    @available(*, unavailable)
    public var textCase: Any /* Text.Case? */ {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var lineLimit: Int? {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var backgroundProminence: Any /* BackgroundProminence */ {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var backgroundStyle: Any? /* AnyShapeStyle? */ {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var appearsActive: Bool {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var dynamicTypeSize: Any /* DynamicTypeSize */ {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var sizeCategory: Any /* ContentSizeCategory */ {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var headerProminence: Any /* Prominence */ {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var allowedDynamicRange: Any? /* Image.DynamicRange? */ {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var symbolVariants: Any /* SymbolVariants */ {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var contentTransition: Any /* ContentTransition */ {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }

    @available(*, unavailable)
    public var contentTransitionAddsDrawingGroup: Bool {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var font: Any? /* Font? */ {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }

    @available(*, unavailable)
    public var imageScale: Any /* Image.Scale */ {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var displayScale: CGFloat {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }

    @available(*, unavailable)
    public var pixelLength: CGFloat {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var legibilityWeight: Any? /* LegibilityWeight? */ {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }

    @available(*, unavailable)
    public var locale: Locale {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }

    @available(*, unavailable)
    public var calendar: Calendar {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }

    @available(*, unavailable)
    public var timeZone: TimeZone {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }

    @available(*, unavailable)
    public var horizontalSizeClass: Any? /* UserInterfaceSizeClass? */ {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }

    @available(*, unavailable)
    public var verticalSizeClass: Any? /* UserInterfaceSizeClass? */ {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var accessibilityEnabled: Bool {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var accessibilityDifferentiateWithoutColor: Bool {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }

    @available(*, unavailable)
    public var accessibilityReduceTransparency: Bool {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }

    @available(*, unavailable)
    public var accessibilityReduceMotion: Bool {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }

    @available(*, unavailable)
    public var accessibilityInvertColors: Bool {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var accessibilityShowButtonShapes: Bool {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    @available(*, unavailable)
    public var accessibilityDimFlashingLights: Bool {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }

    @available(*, unavailable)
    public var accessibilityPlayAnimatedImages: Bool {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    public var colorScheme: ColorScheme {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }

    @available(*, unavailable)
    public var colorSchemeContrast: Any /* ColorSchemeContrast */ {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    public var dismiss: DismissAction {
        get { fatalError("Read via @Environment property wrapper") }
    }

    @available(*, unavailable)
    public var isPresented: Bool {
        get { fatalError("Read via @Environment property wrapper") }
    }
}
