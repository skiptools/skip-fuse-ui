// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation
import SkipBridge
import SkipUI

@MainActor @preconcurrency public struct ShareLink<Data, PreviewImage, PreviewIcon, Label> : View where Data : RandomAccessCollection, /* PreviewImage : Transferable, PreviewIcon : Transferable, */ Label : View /*, Data.Element : Transferable */ {
    private let data: String
    private let subject: Text?
    private let message: Text?
    private let label: UncheckedSendableBox<Label>?

    @available(*, unavailable)
    nonisolated public init(items: Data, subject: Text? = nil, message: Text? = nil, preview: @escaping (Data.Element) -> Any /* SharePreview<PreviewImage, PreviewIcon> */, @ViewBuilder label: () -> Label) {
        fatalError()
    }

    public typealias Body = Never
}

extension ShareLink : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        let javaLabel = label == nil ? nil : label!.wrappedValue.Java_viewOrEmpty
        return SkipUI.ShareLink(text: data, subject: subject?.Java_view as? SkipUI.Text, message: message?.Java_view as? SkipUI.Text, bridgedLabel: javaLabel)
    }
}

extension ShareLink {
    @available(*, unavailable)
    nonisolated public init<I>(item: I, subject: Text? = nil, message: Text? = nil, /* preview: SharePreview<PreviewImage, PreviewIcon>, */ @ViewBuilder label: () -> Label) where Data == CollectionOfOne<I> /*, I : Transferable */ {
        fatalError()
    }
}

extension ShareLink where PreviewImage == Never, PreviewIcon == Never, Data.Element == URL {
    @available(*, unavailable)
    nonisolated public init(items: Data, subject: Text? = nil, message: Text? = nil, @ViewBuilder label: () -> Label) {
        fatalError()
    }
}

extension ShareLink where PreviewImage == Never, PreviewIcon == Never, Data.Element == String {
    @available(*, unavailable)
    nonisolated public init(items: Data, subject: Text? = nil, message: Text? = nil, @ViewBuilder label: () -> Label) {
        fatalError()
    }
}

extension ShareLink where PreviewImage == Never, PreviewIcon == Never {
    nonisolated public init(item: URL, subject: Text? = nil, message: Text? = nil, @ViewBuilder label: () -> Label) where Data == CollectionOfOne<URL> {
        self.data = item.absoluteString
        self.subject = subject
        self.message = message
        self.label = UncheckedSendableBox(label())
    }

    nonisolated public init(item: String, subject: Text? = nil, message: Text? = nil, @ViewBuilder label: () -> Label) where Data == CollectionOfOne<String> {
        self.data = item
        self.subject = subject
        self.message = message
        self.label = UncheckedSendableBox(label())
    }
}

extension ShareLink where Label == EmptyView /* DefaultShareLinkLabel */ {
    @available(*, unavailable)
    nonisolated public init(items: Data, subject: Text? = nil, message: Text? = nil, preview: @escaping (Data.Element) -> Any /* SharePreview<PreviewImage, PreviewIcon> */) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init(_ titleKey: LocalizedStringKey, items: Data, subject: Text? = nil, message: Text? = nil, preview: @escaping (Data.Element) -> Any /* SharePreview<PreviewImage, PreviewIcon> */) {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public init<S>(_ title: S, items: Data, subject: Text? = nil, message: Text? = nil, preview: @escaping (Data.Element) -> Any /* SharePreview<PreviewImage, PreviewIcon> */) where S : StringProtocol {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init(_ title: Text, items: Data, subject: Text? = nil, message: Text? = nil, preview: @escaping (Data.Element) -> Any /* SharePreview<PreviewImage, PreviewIcon> */) {
        fatalError()
    }
}

extension ShareLink where Label == EmptyView /* DefaultShareLinkLabel */ {
    @available(*, unavailable)
    nonisolated public init<I>(item: I, subject: Text? = nil, message: Text? = nil, preview: Any /* SharePreview<PreviewImage, PreviewIcon> */) where Data == CollectionOfOne<I> /*, I : Transferable */ {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<I>(_ titleKey: LocalizedStringKey, item: I, subject: Text? = nil, message: Text? = nil, preview: Any /* SharePreview<PreviewImage, PreviewIcon> */) where Data == CollectionOfOne<I> /*, I : Transferable */ {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public init<S, I>(_ title: S, item: I, subject: Text? = nil, message: Text? = nil, preview: Any /* SharePreview<PreviewImage, PreviewIcon> */) where Data == CollectionOfOne<I>, S : StringProtocol /*, I : Transferable */ {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init<I>(_ title: Text, item: I, subject: Text? = nil, message: Text? = nil, preview: Any /* SharePreview<PreviewImage, PreviewIcon> */) where Data == CollectionOfOne<I> /*, I : Transferable */ {
        fatalError()
    }
}

extension ShareLink where PreviewImage == Never, PreviewIcon == Never, Label == EmptyView /* DefaultShareLinkLabel */, Data.Element == URL {
    @available(*, unavailable)
    nonisolated public init(items: Data, subject: Text? = nil, message: Text? = nil) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init(_ titleKey: LocalizedStringKey, items: Data, subject: Text? = nil, message: Text? = nil) {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public init<S>(_ title: S, items: Data, subject: Text? = nil, message: Text? = nil) where S : StringProtocol {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init(_ title: Text, items: Data, subject: Text? = nil, message: Text? = nil) {
        fatalError()
    }
}

extension ShareLink where PreviewImage == Never, PreviewIcon == Never, Label == EmptyView /* DefaultShareLinkLabel */, Data.Element == String {
    @available(*, unavailable)
    nonisolated public init(items: Data, subject: Text? = nil, message: Text? = nil) {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init(_ titleKey: LocalizedStringKey, items: Data, subject: Text? = nil, message: Text? = nil) {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload nonisolated public init<S>(_ title: S, items: Data, subject: Text? = nil, message: Text? = nil) where S : StringProtocol {
        fatalError()
    }

    @available(*, unavailable)
    nonisolated public init(_ title: Text, items: Data, subject: Text? = nil, message: Text? = nil) {
        fatalError()
    }
}

extension ShareLink where PreviewImage == Never, PreviewIcon == Never, Label == Text /* DefaultShareLinkLabel */ {
    nonisolated public init(item: URL, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<URL> {
        self.data = item.absoluteString
        self.subject = subject
        self.message = message
        self.label = nil
    }

    nonisolated public init(item: String, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<String> {
        self.data = item
        self.subject = subject
        self.message = message
        self.label = nil
    }

    nonisolated public init(_ titleKey: LocalizedStringKey, item: URL, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<URL> {
        self.data = item.absoluteString
        self.subject = subject
        self.message = message
        self.label = UncheckedSendableBox(Text(titleKey))
    }

    nonisolated public init(_ titleKey: LocalizedStringKey, item: String, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<String> {
        self.data = item
        self.subject = subject
        self.message = message
        self.label = UncheckedSendableBox(Text(titleKey))
    }

    @_disfavoredOverload nonisolated public init<S>(_ title: S, item: URL, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<URL>, S : StringProtocol {
        self.data = item.absoluteString
        self.subject = subject
        self.message = message
        self.label = UncheckedSendableBox(Text(title))
    }

    @_disfavoredOverload nonisolated public init<S>(_ title: S, item: String, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<String>, S : StringProtocol {
        self.data = item
        self.subject = subject
        self.message = message
        self.label = UncheckedSendableBox(Text(title))
    }

    nonisolated public init(_ title: Text, item: URL, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<URL> {
        self.data = item.absoluteString
        self.subject = subject
        self.message = message
        self.label = UncheckedSendableBox(title)
    }

    nonisolated public init(_ title: Text, item: String, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<String> {
        self.data = item
        self.subject = subject
        self.message = message
        self.label = UncheckedSendableBox(title)
    }
}
