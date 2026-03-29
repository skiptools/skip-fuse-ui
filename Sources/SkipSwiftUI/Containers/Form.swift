// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipUI

public struct Form<Content> where Content : View {
    private let content: UncheckedSendableBox<Content>

    public init(@ViewBuilder content: () -> Content) {
        self.content = UncheckedSendableBox(content())
    }
}

extension Form : View {
    public typealias Body = Never
}

extension Form : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.Form(bridgedContent: content.wrappedValue.Java_viewOrEmpty)
    }
}

extension Form where Content == FormStyleConfiguration.Content {
    @available(*, unavailable)
    nonisolated public init(_ configuration: FormStyleConfiguration) {
        fatalError()
    }
}

//public struct FormPresentationSizing : PresentationSizing, Sendable {
//    public func proposedSize(for root: PresentationSizingRoot, context: PresentationSizingContext) -> ProposedViewSize
//}

@MainActor @preconcurrency public protocol FormStyle {
    associatedtype Body : View

    @ViewBuilder @MainActor @preconcurrency func makeBody(configuration: Self.Configuration) -> Self.Body

    typealias Configuration = FormStyleConfiguration
}

public struct ColumnsFormStyle : FormStyle {
    public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: ColumnsFormStyle.Configuration) -> some View {
        stubView()
    }
}

extension FormStyle where Self == ColumnsFormStyle {
    @available(*, unavailable)
    @MainActor @preconcurrency public static var columns: ColumnsFormStyle {
        fatalError()
    }
}

public struct GroupedFormStyle : FormStyle {
    public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: ColumnsFormStyle.Configuration) -> some View {
        stubView()
    }
}

extension FormStyle where Self == GroupedFormStyle {
    @available(*, unavailable)
    @MainActor @preconcurrency public static var grouped: GroupedFormStyle {
        fatalError()
    }
}

public struct AutomaticFormStyle : FormStyle {
    public init() {
    }

    @MainActor @preconcurrency public func makeBody(configuration: ColumnsFormStyle.Configuration) -> some View {
        stubView()
    }
}

extension FormStyle where Self == AutomaticFormStyle {
    @MainActor @preconcurrency public static var automatic: AutomaticFormStyle {
        return AutomaticFormStyle()
    }
}

public struct FormStyleConfiguration {
    public struct Content : View {
        public typealias Body = Never
    }

    public let content = FormStyleConfiguration.Content()
}

extension View {
    nonisolated public func formStyle<S>(_ style: S) -> some View where S : FormStyle {
        return self
    }
}
