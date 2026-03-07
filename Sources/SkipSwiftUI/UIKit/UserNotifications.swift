// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation
import SkipBridge
import SkipUI

public final class UNUserNotificationCenter {
    nonisolated(unsafe) private static let shared = UNUserNotificationCenter()

    private init() {
    }

    public static func current() -> UNUserNotificationCenter {
        return shared
    }

    public func notificationSettings() async -> UNNotificationSettings {
        let skipUISettings = await SkipUI.UNUserNotificationCenter.current().notificationSettings()
        return UNNotificationSettings(Java_settings: skipUISettings)
    }

    @available(*, unavailable)
    public func setBadgeCount(_ count: Int) async throws {
    }

    public func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
        return try await SkipUI.UNUserNotificationCenter.current().requestAuthorization(bridgedOptions: options.rawValue)
    }

    public weak var delegate: (any UNUserNotificationCenterDelegate)? {
        get {
            guard let skipUIDelegate = SkipUI.UNUserNotificationCenter.current().delegate else {
                return nil
            }
            if skipUIDelegate is SkipUI.UserNotificationCenterDelegateSupport {
                return _delegate // Using native delegate
            } else if let delegate = skipUIDelegate as? UNUserNotificationCenterDelegate {
                return delegate
            } else {
                return nil
            }
        }
        set {
            let skipUIDelegate: SkipUI.UNUserNotificationCenterDelegate?
            if let delegate = newValue as? SkipUI.UNUserNotificationCenterDelegate {
                _delegate = nil
                skipUIDelegate = delegate
            } else if let newValue {
                _delegate = newValue
                skipUIDelegate = UserNotificationCenterDelegateSupport(didReceive: { [weak newValue] response, completion in
                    guard let newValue else {
                        completion.run()
                        return
                    }
                    let responseBox = UncheckedSendableBox(UNNotificationResponse(Java_response: response))
                    let delegateBox = UncheckedSendableBox(newValue)
                    Task {
                        await delegateBox.wrappedValue.userNotificationCenter(UNUserNotificationCenter.current(), didReceive: responseBox.wrappedValue)
                    }
                }, willPresent: { [weak newValue] notification, completion in
                    guard let newValue else {
                        completion.run(0)
                        return
                    }
                    let notificationBox = UncheckedSendableBox(UNNotification(Java_notification: notification))
                    let delegateBox = UncheckedSendableBox(newValue)
                    Task {
                        let options = await delegateBox.wrappedValue.userNotificationCenter(UNUserNotificationCenter.current(), willPresent: notificationBox.wrappedValue)
                        completion.run(options.rawValue)
                    }
                }, openSettings: { [weak newValue] notification in
                    guard let newValue else {
                        return
                    }
                    let swiftNotification = notification == nil ? nil : UNNotification(Java_notification: notification!)
                    newValue.userNotificationCenter(UNUserNotificationCenter.current(), openSettingsFor: swiftNotification)
                })
            } else {
                _delegate = nil
                skipUIDelegate = nil
            }
            SkipUI.UNUserNotificationCenter.current().delegate = skipUIDelegate
        }
    }
    private weak var _delegate: (any UNUserNotificationCenterDelegate)?

    @available(*, unavailable)
    public var supportsContentExtensions: Bool {
        fatalError()
    }

    public func add(_ request: UNNotificationRequest) async throws {
        try await SkipUI.UNUserNotificationCenter.current().add(request.Java_request)
    }

    public func pendingNotificationRequests() async -> [Any /* UNNotificationRequest */] {
        await SkipUI.UNUserNotificationCenter.current().pendingNotificationRequests()
    }

    public func removePendingNotificationRequests(withIdentifiers: [String]) {
        SkipUI.UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: withIdentifiers)
    }

    public func removeAllPendingNotificationRequests() {
        SkipUI.UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    public func deliveredNotifications() async -> [Any /* UNNotification */] {
        await SkipUI.UNUserNotificationCenter.current().deliveredNotifications()
    }

    public func removeDeliveredNotifications(withIdentifiers: [String]) {
        SkipUI.UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: withIdentifiers)
    }

    public func removeAllDeliveredNotifications() {
        SkipUI.UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }

    @available(*, unavailable)
    public func setNotificationCategories(_ categories: Set<AnyHashable /* UNNotificationCategory */>) {
    }

    @available(*, unavailable)
    public func getNotificationCategories() async -> Set<AnyHashable /* UNNotificationCategory */> {
        fatalError()
    }
}

public protocol UNUserNotificationCenterDelegate : AnyObject {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive notification: UNNotificationResponse) async

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions

    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?)
}

extension UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive notification: UNNotificationResponse) async {
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return []
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
    }
}

public struct UNAuthorizationOptions : OptionSet, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let badge = UNAuthorizationOptions(rawValue: 1 << 0) // For bridging
    public static let sound = UNAuthorizationOptions(rawValue: 1 << 1) // For bridging
    public static let alert = UNAuthorizationOptions(rawValue: 1 << 2) // For bridging
    public static let carPlay = UNAuthorizationOptions(rawValue: 1 << 3) // For bridging
    public static let criticalAlert = UNAuthorizationOptions(rawValue: 1 << 4) // For bridging
    public static let providesAppNotificationSettings = UNAuthorizationOptions(rawValue: 1 << 5) // For bridging
    public static let provisional = UNAuthorizationOptions(rawValue: 1 << 6) // For bridging
}

public final class UNNotification {
    public let request: UNNotificationRequest
    public let date: Date

    public init(request: UNNotificationRequest, date: Date) {
        self.request = request
        self.date = date
    }

    init(Java_notification: SkipUI.UNNotification) {
        self.request = UNNotificationRequest(Java_request: Java_notification.request)
        self.date = Java_notification.date
    }
}

public final class UNNotificationRequest: @unchecked Sendable {
    public let identifier: String
    public let content: UNNotificationContent
    public let trigger: UNNotificationTrigger?

    public init(identifier: String, content: UNNotificationContent, trigger: UNNotificationTrigger?) {
        self.identifier = identifier
        self.content = content
        self.trigger = trigger
    }

    init(Java_request: SkipUI.UNNotificationRequest) {
        self.identifier = Java_request.identifier
        self.content = UNNotificationContent(Java_content: Java_request.content)
        self.trigger = UNPushNotificationTrigger(repeats: false)
    }

    var Java_request: SkipUI.UNNotificationRequest {
        return SkipUI.UNNotificationRequest(identifier: identifier, content: content.Java_content, trigger: trigger?.Java_trigger)
    }
}

public let UNNotificationDefaultActionIdentifier = "UNNotificationDefaultActionIdentifier" // For bridging
public let UNNotificationDismissActionIdentifier = "UNNotificationDismissActionIdentifier" // For bridging

public final class UNNotificationResponse {
    public let actionIdentifier: String
    public let notification: UNNotification

    @available(*, unavailable)
    public var targetScene: Any? /* UIScene? */ {
        fatalError()
    }

    public init(actionIdentifier: String = UNNotificationDefaultActionIdentifier, notification: UNNotification) {
        self.actionIdentifier = actionIdentifier
        self.notification = notification
    }

    init(Java_response: SkipUI.UNNotificationResponse) {
        self.actionIdentifier = Java_response.actionIdentifier
        self.notification = UNNotification(Java_notification: Java_response.notification)
    }
}

public struct UNNotificationPresentationOptions : OptionSet, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let badge = UNNotificationPresentationOptions(rawValue: 1 << 0) // For bridging
    public static let banner = UNNotificationPresentationOptions(rawValue: 1 << 1) // For bridging
    public static let list = UNNotificationPresentationOptions(rawValue: 1 << 2) // For bridging
    public static let sound = UNNotificationPresentationOptions(rawValue: 1 << 3) // For bridging
    public static let alert = UNNotificationPresentationOptions(rawValue: 1 << 4) // For bridging
}

public class UNNotificationContent {
    public internal(set) var title: String
    public internal(set) var subtitle: String
    public internal(set) var body: String
    public internal(set) var badge: Int?
    public internal(set) var sound: UNNotificationSound?
    public internal(set) var launchImageName: String
    public internal(set) var userInfo: [AnyHashable: Any]
    public internal(set) var attachments: [UNNotificationAttachment]
    public internal(set) var categoryIdentifier: String
    public internal(set) var threadIdentifier: String
    public internal(set) var targetContentIdentifier: String?
    public internal(set) var summaryArgument: String
    public internal(set) var summaryArgumentCount: Int
    public internal(set) var filterCriteria: String?

    public init(title: String = "", subtitle: String = "", body: String = "", badge: Int? = nil, sound: UNNotificationSound? = UNNotificationSound.default, launchImageName: String = "", userInfo: [AnyHashable: Any] = [:], attachments: [UNNotificationAttachment] = [], categoryIdentifier: String = "", threadIdentifier: String = "", targetContentIdentifier: String? = nil, summaryArgument: String = "", summaryArgumentCount: Int = 0, filterCriteria: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.badge = badge
        self.sound = sound
        self.launchImageName = launchImageName
        self.userInfo = userInfo
        self.attachments = attachments
        self.categoryIdentifier = categoryIdentifier
        self.threadIdentifier = threadIdentifier
        self.targetContentIdentifier = targetContentIdentifier
        self.summaryArgument = summaryArgument
        self.summaryArgumentCount = summaryArgumentCount
        self.filterCriteria = filterCriteria
    }

    init(Java_content: SkipUI.UNNotificationContent) {
        self.title = Java_content.title
        self.subtitle = Java_content.subtitle
        self.body = Java_content.body
        self.badge = Java_content.bridgedBadge
        self.sound = Java_content.sound == nil ? nil : UNNotificationSound(Java_sound: Java_content.sound!)
        self.launchImageName = Java_content.launchImageName
        self.userInfo = Java_content.bridgedUserInfo
        self.attachments = Java_content.attachments.map { UNNotificationAttachment(Java_attachment: $0) }
        self.categoryIdentifier = Java_content.categoryIdentifier
        self.threadIdentifier = Java_content.threadIdentifier
        self.targetContentIdentifier = Java_content.targetContentIdentifier
        self.summaryArgument = Java_content.summaryArgument
        self.summaryArgumentCount = Java_content.summaryArgumentCount
        self.filterCriteria = Java_content.filterCriteria
    }

    var Java_content: SkipUI.UNNotificationContent {
        return SkipUI.UNNotificationContent.bridgedContent(title: title, subtitle: subtitle, body: body, badge: badge, sound: sound?.Java_sound, launchImageName: launchImageName, userInfo: userInfo, attachments: attachments.map(\.Java_attachment), categoryIdentifier: categoryIdentifier, threadIdentifier: threadIdentifier, targetContentIdentifier: targetContentIdentifier, summaryArgument: summaryArgument, summaryArgumentCount: summaryArgumentCount, filterCriteria: filterCriteria)
    }
}

public final class UNMutableNotificationContent : UNNotificationContent {
    public override var title: String {
        get { super.title }
        set { super.title = newValue }
    }
    public override var subtitle: String {
        get { super.subtitle }
        set { super.subtitle = newValue }
    }
    public override var body: String {
        get { super.body }
        set { super.body = newValue }
    }
    public override var badge: Int? {
        get { super.badge }
        set { super.badge = newValue }
    }
    public override var sound: UNNotificationSound? {
        get { super.sound }
        set { super.sound = newValue }
    }
    public override var launchImageName: String {
        get { super.launchImageName }
        set { super.launchImageName = newValue }
    }
    public override var userInfo: [AnyHashable: Any] {
        get { super.userInfo }
        set { super.userInfo = newValue }
    }
    public override var attachments: [UNNotificationAttachment] {
        get { super.attachments }
        set { super.attachments = newValue }
    }
    public override var categoryIdentifier: String {
        get { super.categoryIdentifier }
        set { super.categoryIdentifier = newValue }
    }
    public override var threadIdentifier: String {
        get { super.threadIdentifier }
        set { super.threadIdentifier = newValue }
    }
    public override var targetContentIdentifier: String? {
        get { super.targetContentIdentifier }
        set { super.targetContentIdentifier = newValue }
    }
    public override var summaryArgument: String {
        get { super.summaryArgument }
        set { super.summaryArgument = newValue }
    }
    public override var summaryArgumentCount: Int {
        get { super.summaryArgumentCount }
        set { super.summaryArgumentCount = newValue }
    }
    public override var filterCriteria: String? {
        get { super.filterCriteria }
        set { super.filterCriteria = newValue }
    }
}

public final class UNNotificationSound {
    public let name: UNNotificationSoundName
    public let volume: Float

    public static var `default`: UNNotificationSound {
        return UNNotificationSound(named: UNNotificationSoundName(rawValue: "default"))
    }

    public static var defaultCriticalSound: UNNotificationSound {
        return UNNotificationSound(named: UNNotificationSoundName(rawValue: "default_critical"))
    }

    public static func defaultCriticalSound(withAudioVolume volume: Float) -> UNNotificationSound {
        return UNNotificationSound(named: UNNotificationSoundName(rawValue: "default_critical"), volume: volume)
    }

    public init(named name: UNNotificationSoundName, volume: Float = Float(0.0)) {
        self.name = name
        self.volume = volume
    }

    public static func soundNamed(_ name: UNNotificationSoundName) -> UNNotificationSound {
        return UNNotificationSound(named: name)
    }

    init(Java_sound: SkipUI.UNNotificationSound) {
        self.name = UNNotificationSoundName(rawValue: Java_sound.bridgedName)
        self.volume = Java_sound.volume
    }

    var Java_sound: SkipUI.UNNotificationSound {
        return SkipUI.UNNotificationSound(named: name.rawValue, volume: volume)
    }
}

public struct UNNotificationSoundName: RawRepresentable, Hashable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public let UNNotificationAttachmentOptionsTypeHintKey = "UNNotificationAttachmentOptionsTypeHintKey"
public let UNNotificationAttachmentOptionsThumbnailHiddenKey = "UNNotificationAttachmentOptionsThumbnailHiddenKey"
public let UNNotificationAttachmentOptionsThumbnailClippingRectKey = "UNNotificationAttachmentOptionsThumbnailClippingRectKey"
public let UNNotificationAttachmentOptionsThumbnailTimeKey = "UNNotificationAttachmentOptionsThumbnailTimeKey"

public class UNNotificationAttachment {
    public let identifier: String
    public let url: URL
    public let type: String
    public let timeShift: TimeInterval

    public init(identifier: String, url: URL, type: String = "public.data", timeShift: TimeInterval = 0) {
        self.identifier = identifier
        self.url = url
        self.type = type
        self.timeShift = timeShift
    }

    public static func attachment(withIdentifier identifier: String, url: URL, options: [AnyHashable: Any]? = nil) throws -> UNNotificationAttachment {
        return UNNotificationAttachment(identifier: identifier, url: url, type: "public.data")
    }

    init(Java_attachment: SkipUI.UNNotificationAttachment) {
        self.identifier = Java_attachment.identifier
        self.url = Java_attachment.url
        self.type = Java_attachment.type
        self.timeShift = Java_attachment.timeShift
    }

    var Java_attachment: SkipUI.UNNotificationAttachment {
        return SkipUI.UNNotificationAttachment(identifier: identifier, url: url, type: type, timeShift: timeShift)
    }
}

public class UNNotificationTrigger {
    public let repeats: Bool

    public init(repeats: Bool) {
        self.repeats = repeats
    }
    
    init(Java_trigger: SkipUI.UNNotificationTrigger) {
        self.repeats = Java_trigger.repeats
    }
    
    var Java_trigger: SkipUI.UNNotificationTrigger {
        return SkipUI.UNNotificationTrigger(repeats: repeats)
    }
}

public final class UNTimeIntervalNotificationTrigger: UNNotificationTrigger {
    public let timeInterval: TimeInterval

    public init(timeInterval: TimeInterval, repeats: Bool) {
        self.timeInterval = timeInterval
        super.init(repeats: repeats)
    }

    init(Java_trigger: SkipUI.UNTimeIntervalNotificationTrigger) {
        self.timeInterval = Java_trigger.timeInterval
        super.init(Java_trigger: Java_trigger)
    }

    override var Java_trigger: SkipUI.UNTimeIntervalNotificationTrigger {
        return SkipUI.UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
    }

    public func nextTriggerDate() -> Date? {
        return Java_trigger.nextTriggerDate()
    }
}

public final class UNCalendarNotificationTrigger: UNNotificationTrigger {
    public let dateComponents: Any /* DateComponents */

    public init(dateMatching dateComponents: Any /* DateComponents */, repeats: Bool) {
        self.dateComponents = dateComponents
        super.init(repeats: repeats)
    }

    init(Java_request: SkipUI.UNCalendarNotificationTrigger) {
        self.dateComponents = Java_request.dateComponents
        super.init(repeats: false)
    }

    override var Java_trigger: SkipUI.UNCalendarNotificationTrigger {
        return SkipUI.UNCalendarNotificationTrigger(dateMatching: dateComponents as! DateComponents, repeats: repeats)
    }

    public func nextTriggerDate() -> Date? {
        return Java_trigger.nextTriggerDate()
    }
}

public final class UNLocationNotificationTrigger: UNNotificationTrigger {
    public let region: Any /* CLRegion */

    public init(region: Any /* CLRegion */, repeats: Bool) {
        self.region = region
        super.init(repeats: repeats)
    }
}

public final class UNPushNotificationTrigger: UNNotificationTrigger {
    public override init(repeats: Bool) {
        super.init(repeats: repeats)
    }
}

public enum UNAuthorizationStatus : Int, Sendable {
    case notDetermined = 0
    case denied = 1
    case authorized = 2
    @available(iOS 12.0, *)
    case provisional = 3
    @available(iOS 14.0, *)
    case ephemeral = 4
}

@available(iOS 11.0, *)
public enum UNShowPreviewsSetting : Int, Sendable {
    case always = 0
    case whenAuthenticated = 1
    case never = 2
}

public enum UNNotificationSetting : Int, Sendable {
    case notSupported = 0
    case disabled = 1
    case enabled = 2
}

public enum UNAlertStyle : Int, Sendable {
    case none = 0
    case banner = 1
    case alert = 2
}

public class UNNotificationSettings {
    private let Java_settings: SkipUI.UNNotificationSettings
    
    public var authorizationStatus: UNAuthorizationStatus {
        return UNAuthorizationStatus(rawValue: Java_settings.authorizationStatus.rawValue) ?? .notDetermined
    }
    
    init(Java_settings: SkipUI.UNNotificationSettings) {
        self.Java_settings = Java_settings
    }
    
    @available(*, unavailable)
    public var soundSetting: UNNotificationSetting {
        fatalError()
    }
    
    @available(*, unavailable)
    public var badgeSetting: UNNotificationSetting {
        fatalError()
    }
    
    @available(*, unavailable)
    public var alertSetting: UNNotificationSetting {
        fatalError()
    }
    
    @available(*, unavailable)
    public var notificationCenterSetting: UNNotificationSetting {
        fatalError()
    }
    
    @available(*, unavailable)
    public var lockScreenSetting: UNNotificationSetting {
        fatalError()
    }
    
    @available(*, unavailable)
    public var carPlaySetting: UNNotificationSetting {
        fatalError()
    }
    
    @available(*, unavailable)
    public var alertStyle: UNAlertStyle {
        fatalError()
    }
    
    @available(iOS 11.0, *)
    @available(*, unavailable)
    public var showPreviewsSetting: UNShowPreviewsSetting {
        fatalError()
    }
    
    @available(iOS 12.0, *)
    @available(*, unavailable)
    public var criticalAlertSetting: UNNotificationSetting {
        fatalError()
    }
    
    @available(iOS 12.0, *)
    @available(*, unavailable)
    public var providesAppNotificationSettings: Bool {
        fatalError()
    }
    
    @available(iOS 13.0, *)
    @available(*, unavailable)
    public var announcementSetting: UNNotificationSetting {
        fatalError()
    }
    
    @available(iOS 15.0, *)
    @available(*, unavailable)
    public var timeSensitiveSetting: UNNotificationSetting {
        fatalError()
    }
    
    @available(iOS 15.0, *)
    @available(*, unavailable)
    public var scheduledDeliverySetting: UNNotificationSetting {
        fatalError()
    }
    
    @available(iOS 15.0, *)
    @available(*, unavailable)
    public var directMessagesSetting: UNNotificationSetting {
        fatalError()
    }
}
