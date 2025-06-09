// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipBridge
import SkipUI

@MainActor @preconcurrency public struct TabView<SelectionValue, Content> : View where SelectionValue : Hashable, Content : View {
    private let selection: UncheckedSendableBox<Binding<SelectionValue>>?
    private let content: UncheckedSendableBox<Content>

    nonisolated public init(selection: Binding<SelectionValue>?, @ViewBuilder content: () -> Content) {
        self.selection = selection == nil ? nil : UncheckedSendableBox(selection!)
        self.content = UncheckedSendableBox(content())
    }

//    nonisolated public init<C>(selection: Binding<SelectionValue>, @TabContentBuilder<SelectionValue> content: () -> C) where Content == TabContentBuilder<SelectionValue>.Content<C>, C : TabContent

    public typealias Body = Never
}

extension TabView : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        let selectionGet: (() -> Any)?
        let selectionSet: ((Any) -> Void)?
        if let selection {
            selectionGet = { Java_swiftHashable(for: selection.wrappedValue.get()) }
            selectionSet = { selection.wrappedValue.set(($0 as! SwiftHashable).base as! SelectionValue) }
        } else {
            selectionGet = nil
            selectionSet = nil
        }
        return SkipUI.TabView(selectionGet: selectionGet, selectionSet: selectionSet, bridgedContent: content.wrappedValue.Java_viewOrEmpty)
    }
}

extension TabView where SelectionValue == Int {
    nonisolated public init(@ViewBuilder content: () -> Content) {
        self.init(selection: nil, content: content)
    }
}

//extension TabView {
//    nonisolated public init<C>(@TabContentBuilder<Never> content: () -> C) where SelectionValue == Never, Content == TabContentBuilder<Never>.Content<C>, C : TabContent
//}

extension View {
    nonisolated public func tabItem<V>(@ViewBuilder _ label: () -> V) -> some View where V : View {
        let label = label()
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.tabItem(bridgedLabel: label.Java_viewOrEmpty)
        }
    }

    nonisolated public func tabViewStyle<S>(_ style: S) -> some View where S : TabViewStyle {
        return ModifierView(target: self) {
            let displayMode = (style as? PageTabViewStyle)?.indexDisplayMode.rawValue
            return $0.Java_viewOrEmpty.tabViewStyle(bridgedStyle: style.identifier, bridgedDisplayMode: displayMode)
        }
    }
}

@MainActor @preconcurrency public protocol TabViewStyle {
    nonisolated var identifier: Int { get } // For bridging
}

extension TabViewStyle {
    nonisolated public var identifier: Int {
        return -1
    }
}

@MainActor @preconcurrency public struct SidebarAdaptableTabViewStyle : TabViewStyle {
    @available(*, unavailable)
    nonisolated public init() {
    }
}

extension TabViewStyle where Self == SidebarAdaptableTabViewStyle {
    @available(*, unavailable)
    @MainActor @preconcurrency public static var sidebarAdaptable: SidebarAdaptableTabViewStyle {
        fatalError()
    }
}

@MainActor @preconcurrency public struct TabBarOnlyTabViewStyle : TabViewStyle {
    nonisolated public init() {
    }

    public let identifier = 1 // For bridging
}

extension TabViewStyle where Self == TabBarOnlyTabViewStyle {
    @MainActor @preconcurrency public static var tabBarOnly: TabBarOnlyTabViewStyle {
        return TabBarOnlyTabViewStyle()
    }
}

@MainActor @preconcurrency public struct DefaultTabViewStyle : TabViewStyle {
    nonisolated public init() {
    }

    public let identifier = 0 // For bridging
}

extension TabViewStyle where Self == DefaultTabViewStyle {
    @MainActor @preconcurrency public static var automatic: DefaultTabViewStyle {
        return DefaultTabViewStyle()
    }
}

@MainActor @preconcurrency public struct GroupedTabViewStyle : TabViewStyle {
    @available(*, unavailable)
    nonisolated public init() {
    }
}

extension TabViewStyle where Self == GroupedTabViewStyle {
    @available(*, unavailable)
    @MainActor @preconcurrency public static var grouped: GroupedTabViewStyle {
        fatalError()
    }
}

@MainActor @preconcurrency public struct PageTabViewStyle: TabViewStyle, Sendable {
    public let indexDisplayMode: PageTabViewStyle.IndexDisplayMode

    public struct IndexDisplayMode : RawRepresentable, Equatable, Sendable {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let automatic = IndexDisplayMode(rawValue: 0) // For bridging
        public static let always = IndexDisplayMode(rawValue: 1) // For bridging
        public static let never = IndexDisplayMode(rawValue: 2) // For bridging
    }

    nonisolated public init(indexDisplayMode: PageTabViewStyle.IndexDisplayMode = .automatic) {
        self.indexDisplayMode = indexDisplayMode
    }

    public let identifier = 2 // For bridging
}

extension TabViewStyle where Self == PageTabViewStyle {
    @MainActor @preconcurrency public static var page: PageTabViewStyle {
        return PageTabViewStyle()
    }

    @MainActor @preconcurrency public static func page(indexDisplayMode: PageTabViewStyle.IndexDisplayMode) -> PageTabViewStyle {
        return PageTabViewStyle(indexDisplayMode: indexDisplayMode)
    }
}
