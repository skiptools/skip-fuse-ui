// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

/* @MainActor @preconcurrency */ public struct Form<Content> : View where Content : View {
    private let content: Content

    /* nonisolated */ public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public typealias Body = Never
}

extension Form : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.Form(bridgedContent: content.Java_viewOrEmpty)
    }
}

extension Form where Content == FormStyleConfiguration.Content {
    @available(*, unavailable)
    /* nonisolated */ public init(_ configuration: FormStyleConfiguration) {
        fatalError()
    }
}

//public struct FormPresentationSizing : PresentationSizing, Sendable {
//    public func proposedSize(for root: PresentationSizingRoot, context: PresentationSizingContext) -> ProposedViewSize
//}

/* @MainActor @preconcurrency */ public protocol FormStyle {
    associatedtype Body : View

    @ViewBuilder @MainActor /* @preconcurrency */ func makeBody(configuration: Self.Configuration) -> Self.Body

    typealias Configuration = FormStyleConfiguration
}

/* @MainActor @preconcurrency */ public struct ColumnsFormStyle : FormStyle {
    /* @MainActor @preconcurrency */ public init() {
    }

    @MainActor /* @preconcurrency */ public func makeBody(configuration: ColumnsFormStyle.Configuration) -> some View {
        stubView()
    }
}

extension FormStyle where Self == ColumnsFormStyle {
    @available(*, unavailable)
    /* @MainActor @preconcurrency */ public static var columns: ColumnsFormStyle {
        fatalError()
    }
}

/* @MainActor @preconcurrency */ public struct GroupedFormStyle : FormStyle {
    /* @MainActor @preconcurrency */ public init() {
    }

    @MainActor /* @preconcurrency */ public func makeBody(configuration: ColumnsFormStyle.Configuration) -> some View {
        stubView()
    }
}

extension FormStyle where Self == GroupedFormStyle {
    @available(*, unavailable)
    /* @MainActor @preconcurrency */ public static var grouped: GroupedFormStyle {
        fatalError()
    }
}

/* @MainActor @preconcurrency */ public struct AutomaticFormStyle : FormStyle {
    /* @MainActor @preconcurrency */ public init() {
    }

    @MainActor /* @preconcurrency */ public func makeBody(configuration: ColumnsFormStyle.Configuration) -> some View {
        stubView()
    }
}

extension FormStyle where Self == AutomaticFormStyle {
    /* @MainActor @preconcurrency */ public static var automatic: AutomaticFormStyle {
        return AutomaticFormStyle()
    }
}

public struct FormStyleConfiguration {
    /* @MainActor @preconcurrency */ public struct Content : View {
        public typealias Body = Never
    }

    public let content = FormStyleConfiguration.Content()
}

extension View {
    /* nonisolated */ public func formStyle<S>(_ style: S) -> some View where S : FormStyle {
        return self
    }
}
