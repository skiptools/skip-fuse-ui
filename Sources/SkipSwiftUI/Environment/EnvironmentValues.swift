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
    nonisolated(unsafe) static let shared = EnvironmentValues()

    /// Return a bridgable key to use for the given key path value.
    static func key<Value>(for keyPath: KeyPath<EnvironmentValues, Value>) -> String {
        return key(forAny: keyPath)
    }

    /// Return a bridgable key to use for the given observable value.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    static func key<T>(for type: T.Type) -> String where T: Observable {
        return key(forAny: String(describing: type))
    }

    // MARK: - Builtin EnvironmentValues bridging
    // Note: Must be matched by equivalent code in SkipUI.EnvironmentValues

    /// Convert a builtin environment value from Compose.
    static func builtin(key: String, bridgedValue: Any?) -> Any? {
        switch key {
        case "autocorrectionDisabled":
            return bridgedValue as? Bool == true
        case "backgroundStyle":
            return JavaBackedView((bridgedValue as? JConvertible)?.toJavaObject(options: [])).map { AnyShapeStyle($0) }
        case "colorScheme":
            let rawValue = bridgedValue as? Int
            return rawValue == nil ? ColorScheme.light : ColorScheme(rawValue: rawValue!) ?? .light
        case "dismiss":
            let action = (bridgedValue as? SkipUI.DismissAction)?.action ?? { }
            let actionBox = UncheckedSendableBox(action)
            return DismissAction(action: { actionBox.wrappedValue() })
        case "font":
            if let font = bridgedValue as? SkipUI.Font {
                return Font(spec: FontSpec(.java(font)))
            } else {
                return nil
            }
        case "horizontalSizeClass":
            let rawValue = bridgedValue as? Int
            return rawValue == nil ? nil : UserInterfaceSizeClass(rawValue: rawValue!) ?? .regular
        case "isEnabled":
            return bridgedValue as? Bool != false
        case "isSearching":
            return bridgedValue as? Bool == true
        case "layoutDirection":
            let rawValue = bridgedValue as? Int
            return rawValue == nil ? LayoutDirection.leftToRight : LayoutDirection(rawValue: rawValue!) ?? .leftToRight
        case "lineLimit":
            return bridgedValue as? Int
        case "locale":
            return bridgedValue as? Locale ?? Locale.current
        case "openURL":
            let javaAction = bridgedValue as? SkipUI.OpenURLAction
            let javaHandler = javaAction?.handler ?? { _ in SkipUI.OpenURLAction.Result(rawValue: OpenURLAction.Result.systemAction.identifier) }
            let javaSystemHandler = javaAction?.systemHandler ?? { _ in }
            let javaHandlerBox = UncheckedSendableBox(javaHandler)
            let javaSystemHandlerBox = UncheckedSendableBox(javaSystemHandler)
            return OpenURLAction(handler: {
                let result = javaHandlerBox.wrappedValue($0)
                return OpenURLAction.Result(identifier: result.rawValue, url: result.url)
            }, systemHandler: { try javaSystemHandlerBox.wrappedValue($0) })
        case "refresh":
            guard let javaAction = bridgedValue as? SkipUI.RefreshAction else {
                return nil
            }
            let javaActionBox = UncheckedSendableBox(javaAction)
            return RefreshAction {
                Task {
                    await withCheckedContinuation { continuation in
                        javaActionBox.wrappedValue.run { continuation.resume() }
                    }
                }
            }
        case "scenePhase":
            let rawValue = bridgedValue as? Int
            return rawValue == nil ? ScenePhase.active : ScenePhase(rawValue: rawValue!) ?? .active
        case "scrollDismissesKeyboardMode":
            let identifier = bridgedValue as? Int
            return identifier == nil ? ScrollDismissesKeyboardMode.automatic : ScrollDismissesKeyboardMode(identifier: identifier!)
        case "timeZone":
            let identifier = bridgedValue as? String
            return identifier == nil ? TimeZone.current : TimeZone(identifier: identifier!) ?? .current
        case "verticalSizeClass":
            let rawValue = bridgedValue as? Int
            return rawValue == nil ? nil : UserInterfaceSizeClass(rawValue: rawValue!) ?? .regular
        default:
            return nil
        }
    }

    /// Convert a builtin environment value to Compose.
    static func bridgeBuiltin(key: String, value: Any?) -> Any? {
        switch key {
        case "autocorrectionDisabled":
            return value as? Bool == true
        case "backgroundStyle":
            return (value as? any ShapeStyle)?.Java_view
        case "colorScheme":
            return (value as? ColorScheme)?.rawValue
        case "dismiss":
            guard let action = (value as? DismissAction)?.action else {
                return nil
            }
            #if compiler(>=6.0)
            return SkipUI.DismissAction(action: { MainActor.assumeIsolated { action() } })
            #else
            return SkipUI.DismissAction(action: action)
            #endif
        case "font":
            return (value as? Font)?.spec.Java_font
        case "horizontalSizeClass":
            return (value as? UserInterfaceSizeClass)?.rawValue
        case "isEnabled":
            return value as? Bool != false
        case "isSearching":
            return value as? Bool == true
        case "layoutDirection":
            return ((value as? LayoutDirection) ?? .leftToRight).rawValue
        case "lineLimit":
            return value as? Int
        case "locale":
            return value as? Locale ?? Locale.current
        case "openURL":
            guard let openURLAction = value as? OpenURLAction else {
                return nil
            }
            let javaHandler: (URL) -> SkipUI.OpenURLAction.Result = { url in
                #if compiler(>=6.0)
                let result = MainActor.assumeIsolated { openURLAction.handler(url) }
                #else
                let result = openURLAction.handler(url)
                #endif
                return SkipUI.OpenURLAction.Result(rawValue: result.identifier, url: result.url)
            }
            if let javaSystemHandler = openURLAction.systemHandler {
                return SkipUI.OpenURLAction(handler: javaHandler, systemHandler: { url in
                    #if compiler(>=6.0)
                    try MainActor.assumeIsolated { try javaSystemHandler(url) }
                    #else
                    try javaSystemHandler(url)
                    #endif
                })
            } else {
                return SkipUI.OpenURLAction(handler: javaHandler)
            }
        case "refresh":
            guard let refreshAction = value as? RefreshAction else {
                return nil
            }
            let bridgedAction: (SkipUI.CompletionHandler) -> Void = { completionHandler in
                let task = Task {
                    await refreshAction()
                    completionHandler.run()
                }
                completionHandler.onCancel = { task.cancel() }
            }
            return SkipUI.RefreshAction(bridgedAction: bridgedAction)
        case "scenePhase":
            return (value as? ScenePhase ?? .active).rawValue
        case "scrollDismissesKeyboardMode":
            return (value as? ScrollDismissesKeyboardMode ?? .automatic).identifier
        case "timeZone":
            return (value as? TimeZone ?? TimeZone.current).identifier
        case "verticalSizeClass":
            return (value as? UserInterfaceSizeClass)?.rawValue
        default:
            return nil
        }
    }

    nonisolated(unsafe) private static var keys: [AnyHashable: String] = {
        var keys: [AnyHashable: String] = [:]
        // Initialize builtins
        keys[\EnvironmentValues.autocorrectionDisabled] = "autocorrectionDisabled"
        keys[\EnvironmentValues.backgroundStyle] = "backgroundStyle"
        keys[\EnvironmentValues.colorScheme] = "colorScheme"
        keys[\EnvironmentValues.dismiss] = "dismiss"
        keys[\EnvironmentValues.font] = "font"
        keys[\EnvironmentValues.horizontalSizeClass] = "horizontalSizeClass"
        keys[\EnvironmentValues.isEnabled] = "isEnabled"
        keys[\EnvironmentValues.isSearching] = "isSearching"
        keys[\EnvironmentValues.layoutDirection] = "layoutDirection"
        keys[\EnvironmentValues.lineLimit] = "lineLimit"
        keys[\EnvironmentValues.locale] = "locale"
        keys[\EnvironmentValues.openURL] = "openURL"
        keys[\EnvironmentValues.refresh] = "refresh"
        keys[\EnvironmentValues.scenePhase] = "scenePhase"
        keys[\EnvironmentValues.scrollDismissesKeyboardMode] = "scrollDismissesKeyboardMode"
        keys[\EnvironmentValues.timeZone] = "timeZone"
        keys[\EnvironmentValues.verticalSizeClass] = "verticalSizeClass"
        return keys
    }()

    // MARK: -

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
    nonisolated(unsafe) private static var _nextKey = 0
}

extension View {
    nonisolated public func environment<V>(_ keyPath: WritableKeyPath<EnvironmentValues, V>, _ value: V) -> some View {
        return ModifierView(target: self) {
            let key = EnvironmentValues.key(for: keyPath)
            let view = $0.Java_viewOrEmpty
            if key.hasPrefix("userkey:") {
                let ptr = SwiftObjectPointer.pointer(to: Box(value), retain: true)
                let support = EnvironmentSupport(valueHolder: ptr)
                return view.environment(bridgedKey: key, value: support)
            } else {
                let value = EnvironmentValues.bridgeBuiltin(key: key, value: value)
                let support = EnvironmentSupport(builtinValue: value)
                return view.environment(bridgedKey: key, value: support)
            }
        }
    }

    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    nonisolated public func environment<T>(_ object: T?) -> some View where T : AnyObject, T : Observable {
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
    public var autocorrectionDisabled: Bool {
        fatalError("Read via @Environment property wrapper")
    }
}

extension EnvironmentValues {
    public var layoutDirection: LayoutDirection {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    public var isEnabled: Bool {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    public var openURL: OpenURLAction {
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
    public var backgroundStyle: AnyShapeStyle? {
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
    public var scenePhase: ScenePhase {
        get { fatalError("Read via @Environment property wrapper") }
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
    public var font: Font? {
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

    public var locale: Locale {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }

    @available(*, unavailable)
    public var calendar: Calendar {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }

    public var timeZone: TimeZone {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }

    public var horizontalSizeClass: UserInterfaceSizeClass? {
        fatalError("Read via @Environment property wrapper")
    }

    public var verticalSizeClass: UserInterfaceSizeClass? {
        fatalError("Read via @Environment property wrapper")
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

extension EnvironmentValues {
    public var refresh: RefreshAction? {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}

extension EnvironmentValues {
    public var isSearching: Bool {
        get { fatalError("Read via @Environment property wrapper") }
    }
}

extension EnvironmentValues {
    public var scrollDismissesKeyboardMode: ScrollDismissesKeyboardMode {
        get { fatalError("Read via @Environment property wrapper") }
        set { fatalError("Set via dedicated View modifier") }
    }
}
