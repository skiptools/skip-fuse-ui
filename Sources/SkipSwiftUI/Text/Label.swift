// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

@MainActor @preconcurrency public struct Label<Title, Icon> : View where Title : View, Icon : View {
    private let title: UncheckedSendableBox<Title>
    private let icon: UncheckedSendableBox<Icon>

    nonisolated public init(@ViewBuilder title: () -> Title, @ViewBuilder icon: () -> Icon) {
        self.title = UncheckedSendableBox(title())
        self.icon = UncheckedSendableBox(icon())
    }

    public typealias Body = Never
}

extension Label : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.Label(bridgedTitle: title.wrappedValue.Java_viewOrEmpty, bridgedImage: icon.wrappedValue.Java_viewOrEmpty)
    }
}

extension Label where Title == Text, Icon == Image {
    nonisolated public init(_ titleKey: LocalizedStringKey, image name: String) {
        self.title = UncheckedSendableBox(Text(titleKey))
        self.icon = UncheckedSendableBox(Image(name, bundle: .main))
    }

    nonisolated public init(_ titleKey: LocalizedStringKey, systemImage name: String) {
        self.title = UncheckedSendableBox(Text(titleKey))
        self.icon = UncheckedSendableBox(Image(systemName: name))
    }

    @_disfavoredOverload nonisolated public init<S>(_ title: S, image name: String) where S : StringProtocol {
        self.title = UncheckedSendableBox(Text(title))
        self.icon = UncheckedSendableBox(Image(name, bundle: .main))
    }

    @_disfavoredOverload nonisolated public init<S>(_ title: S, systemImage name: String) where S : StringProtocol {
        self.title = UncheckedSendableBox(Text(title))
        self.icon = UncheckedSendableBox(Image(systemName: name))
    }
}

//extension Label where Title == Text, Icon == Image {
//    nonisolated public init(_ titleKey: LocalizedStringKey, image resource: ImageResource)
//
//    nonisolated public init<S>(_ title: S, image resource: ImageResource) where S : StringProtocol
//}

extension Label where Title == LabelStyleConfiguration.Title, Icon == LabelStyleConfiguration.Icon {
    @available(*, unavailable)
    nonisolated public init(_ configuration: LabelStyleConfiguration) {
        fatalError()
    }
}

@MainActor @preconcurrency public protocol LabelStyle {
    associatedtype Body : View

    @ViewBuilder @MainActor @preconcurrency func makeBody(configuration: Self.Configuration) -> Self.Body

    typealias Configuration = LabelStyleConfiguration

    nonisolated var identifier: Int { get } // For bridging
}

extension LabelStyle {
    nonisolated public var identifier: Int {
        return -1
    }
}

@MainActor @preconcurrency public struct DefaultLabelStyle : LabelStyle {
    @MainActor @preconcurrency public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: DefaultLabelStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 0 // For bridging
}

extension LabelStyle where Self == DefaultLabelStyle {
    @MainActor @preconcurrency public static var automatic: DefaultLabelStyle {
        return DefaultLabelStyle()
    }
}

@MainActor @preconcurrency public struct IconOnlyLabelStyle : LabelStyle {
    @MainActor @preconcurrency public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: IconOnlyLabelStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 2 // For bridging
}

extension LabelStyle where Self == IconOnlyLabelStyle {
    @MainActor @preconcurrency public static var iconOnly: IconOnlyLabelStyle {
        return IconOnlyLabelStyle()
    }
}

@MainActor @preconcurrency public struct TitleAndIconLabelStyle : LabelStyle {
    @MainActor @preconcurrency public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: TitleAndIconLabelStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 3 // For bridging
}

extension LabelStyle where Self == TitleAndIconLabelStyle {
    @MainActor @preconcurrency public static var titleAndIcon: TitleAndIconLabelStyle {
        return TitleAndIconLabelStyle()
    }
}

@MainActor @preconcurrency public struct TitleOnlyLabelStyle : LabelStyle {
    @MainActor @preconcurrency public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: TitleOnlyLabelStyle.Configuration) -> some View {
        stubView()
    }

    public let identifier = 1 // For bridging
}

extension LabelStyle where Self == TitleOnlyLabelStyle {
    @MainActor @preconcurrency public static var titleOnly: TitleOnlyLabelStyle {
        return TitleOnlyLabelStyle()
    }
}

public struct LabelStyleConfiguration {
    @MainActor @preconcurrency public struct Title : View {
        public typealias Body = Never
    }

    @MainActor @preconcurrency public struct Icon : View {
        public typealias Body = Never
    }

    public var title: LabelStyleConfiguration.Title {
        return Title()
    }

    public var icon: LabelStyleConfiguration.Icon {
        return Icon()
    }
}

extension View {
    nonisolated public func labelStyle<S>(_ style: S) -> some View where S : LabelStyle {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.labelStyle(bridgedStyle: style.identifier)
        }
    }
}
