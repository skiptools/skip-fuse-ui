// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation
import SkipAndroidBridge
import SkipUI

/* @MainActor */ open class UIApplication : NSObject /*, UIResponder */ {
    open class var shared: UIApplication {
        return _shared
    }
    nonisolated(unsafe) private static let _shared = UIApplication()

    private let application: SkipUI.UIApplication

    private override init() {
        self.application = SkipUI.UIApplication.shared
    }

    #if os(Android)
    /// Access the main Android `androidx.appcompat.app.AppCompatActivity` as a dynamic object.
    public func dynamicAndroidActivity(options: JConvertibleOptions = .kotlincompat) -> DynamicAppCompatActivity? {
        guard let activity = application.androidActivity?.toJavaObject(options: options) else {
            return nil
        }
        return try! DynamicAppCompatActivity(for: activity, options: options)
    }

    /// Requests the given Android permission.
    /// - Parameter permission: The name of the permission, such as `android.permission.POST_NOTIFICATIONS`.
    /// - Returns: `true` if the permission was granted, `false` if denied or there was an error making the request.
    public func requestPermission(_ permission: String) async -> Bool {
        return await application.requestPermission(permission)
    }
    #endif

    @available(*, unavailable)
    unowned(unsafe) open var delegate: AnyObject? /* (any UIApplicationDelegate)? */ {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }

    open var isIdleTimerDisabled: Bool {
        get {
            return application.isIdleTimerDisabled
        }
        set {
            application.isIdleTimerDisabled = newValue
        }
    }

    @available(*, unavailable)
    nonisolated open func canOpenURL(_ url: URL) -> Bool {
        fatalError()
    }

    @available(*, unavailable)
    open func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:], completionHandler completion: (@MainActor /* @Sendable */ (Bool) -> Void)? = nil) {
        fatalError()
    }

    open func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:]) async -> Bool {
        let keyedOptions = options.reduce(into: [String: Any]()) { result, entry in
            result[entry.key.rawValue] = entry.value
        }
        return await application.bridgedOpen(url, options: keyedOptions)
    }

    @available(*, unavailable)
    open func sendEvent(_ event: Any /* UIEvent */) {
        fatalError()
    }

    @available(*, unavailable)
    open func sendAction(_ action: Any /* Selector */, to target: Any?, from sender: Any?, for event: Any /* UIEvent? */) -> Bool {
        fatalError()
    }

    @available(*, unavailable)
    open func supportedInterfaceOrientations(for window: Any /* UIWindow? */) -> Any /* UIInterfaceOrientationMask */ {
        fatalError()
    }

    @available(*, unavailable)
    open var applicationIconBadgeNumber: Int {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }

    @available(*, unavailable)
    open var applicationSupportsShakeToEdit: Bool {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }

    open var applicationState: UIApplication.State {
        return UIApplication.State(rawValue: application.bridgedApplicationState) ?? .active
    }

    @available(*, unavailable)
    nonisolated open var backgroundTimeRemaining: TimeInterval {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated open func beginBackgroundTask(expirationHandler handler: (@MainActor /* @Sendable */ () -> Void)? = nil) -> Any /* UIBackgroundTaskIdentifier */ {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated open func beginBackgroundTask(withName taskName: String?, expirationHandler handler: (@MainActor /* @Sendable */ () -> Void)? = nil) -> Any /* UIBackgroundTaskIdentifier */ {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated open func endBackgroundTask(_ identifier: Any /* UIBackgroundTaskIdentifier */) {
        fatalError()
    }

    @available(*, unavailable)
    open var backgroundRefreshStatus: Any /* UIBackgroundRefreshStatus */ {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated open var isProtectedDataAvailable: Bool {
        fatalError()
    }

    @available(*, unavailable)
    open var userInterfaceLayoutDirection: Any /* UIUserInterfaceLayoutDirection */ {
        fatalError()
    }

    @available(*, unavailable)
    open var preferredContentSizeCategory: Any /* UIContentSizeCategory */ {
        fatalError()
    }

    @available(*, unavailable)
    open var connectedScenes: Set<AnyHashable /* UIScene */> {
        fatalError()
    }

    @available(*, unavailable)
    open var openSessions: Set<AnyHashable /* UISceneSession */> {
        fatalError()
    }

    @available(*, unavailable)
    open var supportsMultipleScenes: Bool {
        fatalError()
    }

    @available(*, unavailable)
    open func requestSceneSessionDestruction(_ sceneSession: Any /* UISceneSession */, options: Any? /* UISceneDestructionRequestOptions? */, errorHandler: ((any Error) -> Void)? = nil) {
        fatalError()
    }

    @available(*, unavailable)
    open func requestSceneSessionRefresh(_ sceneSession: Any /* UISceneSession */) {
        fatalError()
    }
}

extension UIApplication {
    @available(*, unavailable)
    @MainActor @preconcurrency public func activateSceneSession(for request: Any /* UISceneSessionActivationRequest */, errorHandler: ((any Error) -> Void)? = nil) {
        fatalError()
    }
}

extension UIApplication {
    nonisolated public static let openNotificationSettingsURLString = "openNotificationSettingsURLString"
}

extension UIApplication {
    @available(*, unavailable)
    public func registerForRemoteNotifications() {
        fatalError()
    }

    @available(*, unavailable)
    public func unregisterForRemoteNotifications() {
        fatalError()
    }

    @available(*, unavailable)
    public var isRegisteredForRemoteNotifications: Bool {
        fatalError()
    }
}

extension UIApplication {
    @available(*, unavailable)
    public func beginReceivingRemoteControlEvents() {
        fatalError()
    }

    @available(*, unavailable)
    public func endReceivingRemoteControlEvents() {
        fatalError()
    }
}

extension UIApplication {
    @available(*, unavailable)
    public var shortcutItems: [Any /* UIApplicationShortcutItem */]? {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }
}

extension UIApplication {
    @available(*, unavailable)
    public var supportsAlternateIcons: Bool {
        fatalError()
    }

    @available(*, unavailable)
    public func setAlternateIconName(_ alternateIconName: String?, completionHandler: (((any Error)?) -> Void)? = nil) {
        fatalError()
    }

    @available(*, unavailable)
    public func setAlternateIconName(_ alternateIconName: String?) async throws {
        fatalError()
    }

    @available(*, unavailable)
    public var alternateIconName: String? {
        fatalError()
    }
}

extension UIApplication {
    @available(*, unavailable)
    public func extendStateRestoration() {
        fatalError()
    }

    @available(*, unavailable)
    public func completeStateRestoration() {
        fatalError()
    }

    @available(*, unavailable)
    public func ignoreSnapshotOnNextApplicationLaunch() {
        fatalError()
    }

    @available(*, unavailable)
    public class func registerObject(forStateRestoration object: Any /* any UIStateRestoring */, restorationIdentifier: String) {
        fatalError()
    }
}

extension UIApplication {
    public struct LaunchOptionsKey : Hashable, Equatable, RawRepresentable, @unchecked Sendable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    public struct OpenURLOptionsKey : Hashable, Equatable, RawRepresentable, @unchecked Sendable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    public struct ExtensionPointIdentifier : Hashable, Equatable, RawRepresentable, @unchecked Sendable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    @available(*, unavailable)
    nonisolated public class var didEnterBackgroundNotification: NSNotification.Name {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public class var willEnterForegroundNotification: NSNotification.Name {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public class var didFinishLaunchingNotification: NSNotification.Name {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public class var didBecomeActiveNotification: NSNotification.Name {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public class var willResignActiveNotification: NSNotification.Name {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public class var didReceiveMemoryWarningNotification: NSNotification.Name {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public class var willTerminateNotification: NSNotification.Name {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public class var significantTimeChangeNotification: NSNotification.Name {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public class var backgroundRefreshStatusDidChangeNotification: NSNotification.Name {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public class var protectedDataWillBecomeUnavailableNotification: NSNotification.Name {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public class var protectedDataDidBecomeAvailableNotification: NSNotification.Name {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public class var openSettingsURLString: String {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public class var userDidTakeScreenshotNotification: NSNotification.Name {
        fatalError()
    }

    @available(*, unavailable)
    public class var invalidInterfaceOrientationException: NSExceptionName {
        fatalError()
    }

    public enum State : Int, Sendable {
        case active = 0
        case inactive = 1
        case background = 2
    }

    @available(*, unavailable)
    public class var backgroundFetchIntervalMinimum: TimeInterval {
        fatalError()
    }

    @available(*, unavailable)
    public class var backgroundFetchIntervalNever: TimeInterval {
        fatalError()
    }

    public struct OpenExternalURLOptionsKey : Hashable, Equatable, RawRepresentable, Sendable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public static let universalLinksOnly = OpenExternalURLOptionsKey(rawValue: "universalLinksOnly")
        public static let eventAttribution = OpenExternalURLOptionsKey(rawValue: "eventAttribution")
    }
}
