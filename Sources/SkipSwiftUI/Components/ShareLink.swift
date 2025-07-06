// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation
import SkipFuse
import SkipUI

public struct ShareLink<Data, PreviewImage, PreviewIcon, Label> where Data : RandomAccessCollection, /* PreviewImage : Transferable, PreviewIcon : Transferable, */ Label : View /*, Data.Element : Transferable */ {
    private let data: String
    private let subject: Text?
    private let message: Text?
    private let label: Label?

    @available(*, unavailable)
    public init(items: Data, subject: Text? = nil, message: Text? = nil, preview: @escaping (Data.Element) -> Any /* SharePreview<PreviewImage, PreviewIcon> */, @ViewBuilder label: () -> Label) {
        fatalError()
    }
}

extension ShareLink : View {
    public typealias Body = Never
}

extension ShareLink : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.ShareLink(text: data, subject: subject?.Java_view as? SkipUI.Text, message: message?.Java_view as? SkipUI.Text, bridgedLabel: label?.Java_viewOrEmpty)
    }
}

extension ShareLink {
    @available(*, unavailable)
    public init<I>(item: I, subject: Text? = nil, message: Text? = nil, /* preview: SharePreview<PreviewImage, PreviewIcon>, */ @ViewBuilder label: () -> Label) where Data == CollectionOfOne<I> /*, I : Transferable */ {
        fatalError()
    }
}

extension ShareLink where PreviewImage == Never, PreviewIcon == Never, Data.Element == URL {
    @available(*, unavailable)
    public init(items: Data, subject: Text? = nil, message: Text? = nil, @ViewBuilder label: () -> Label) {
        fatalError()
    }
}

extension ShareLink where PreviewImage == Never, PreviewIcon == Never, Data.Element == String {
    @available(*, unavailable)
    public init(items: Data, subject: Text? = nil, message: Text? = nil, @ViewBuilder label: () -> Label) {
        fatalError()
    }
}

extension ShareLink where PreviewImage == Never, PreviewIcon == Never {
    public init(item: URL, subject: Text? = nil, message: Text? = nil, @ViewBuilder label: () -> Label) where Data == CollectionOfOne<URL> {
        self.data = item.absoluteString
        self.subject = subject
        self.message = message
        self.label = label()
    }

    public init(item: String, subject: Text? = nil, message: Text? = nil, @ViewBuilder label: () -> Label) where Data == CollectionOfOne<String> {
        self.data = item
        self.subject = subject
        self.message = message
        self.label = label()
    }
}

extension ShareLink where Label == EmptyView /* DefaultShareLinkLabel */ {
    @available(*, unavailable)
    public init(items: Data, subject: Text? = nil, message: Text? = nil, preview: @escaping (Data.Element) -> Any /* SharePreview<PreviewImage, PreviewIcon> */) {
        fatalError()
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, items: Data, subject: Text? = nil, message: Text? = nil, preview: @escaping (Data.Element) -> Any /* SharePreview<PreviewImage, PreviewIcon> */) {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, items: Data, subject: Text? = nil, message: Text? = nil, preview: @escaping (Data.Element) -> Any /* SharePreview<PreviewImage, PreviewIcon> */) {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload public init<S>(_ title: S, items: Data, subject: Text? = nil, message: Text? = nil, preview: @escaping (Data.Element) -> Any /* SharePreview<PreviewImage, PreviewIcon> */) where S : StringProtocol {
        fatalError()
    }

    @available(*, unavailable)
    public init(_ title: Text, items: Data, subject: Text? = nil, message: Text? = nil, preview: @escaping (Data.Element) -> Any /* SharePreview<PreviewImage, PreviewIcon> */) {
        fatalError()
    }
}

extension ShareLink where Label == EmptyView /* DefaultShareLinkLabel */ {
    @available(*, unavailable)
    public init<I>(item: I, subject: Text? = nil, message: Text? = nil, preview: Any /* SharePreview<PreviewImage, PreviewIcon> */) where Data == CollectionOfOne<I> /*, I : Transferable */ {
        fatalError()
    }

    @available(*, unavailable)
    public init<I>(_ titleKey: LocalizedStringKey, item: I, subject: Text? = nil, message: Text? = nil, preview: Any /* SharePreview<PreviewImage, PreviewIcon> */) where Data == CollectionOfOne<I> /*, I : Transferable */ {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload public init<I>(_ titleResource: AndroidLocalizedStringResource, item: I, subject: Text? = nil, message: Text? = nil, preview: Any /* SharePreview<PreviewImage, PreviewIcon> */) where Data == CollectionOfOne<I> /*, I : Transferable */ {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload public init<S, I>(_ title: S, item: I, subject: Text? = nil, message: Text? = nil, preview: Any /* SharePreview<PreviewImage, PreviewIcon> */) where Data == CollectionOfOne<I>, S : StringProtocol /*, I : Transferable */ {
        fatalError()
    }

    @available(*, unavailable)
    public init<I>(_ title: Text, item: I, subject: Text? = nil, message: Text? = nil, preview: Any /* SharePreview<PreviewImage, PreviewIcon> */) where Data == CollectionOfOne<I> /*, I : Transferable */ {
        fatalError()
    }
}

extension ShareLink where PreviewImage == Never, PreviewIcon == Never, Label == EmptyView /* DefaultShareLinkLabel */, Data.Element == URL {
    @available(*, unavailable)
    public init(items: Data, subject: Text? = nil, message: Text? = nil) {
        fatalError()
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, items: Data, subject: Text? = nil, message: Text? = nil) {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, items: Data, subject: Text? = nil, message: Text? = nil) {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload public init<S>(_ title: S, items: Data, subject: Text? = nil, message: Text? = nil) where S : StringProtocol {
        fatalError()
    }

    @available(*, unavailable)
    public init(_ title: Text, items: Data, subject: Text? = nil, message: Text? = nil) {
        fatalError()
    }
}

extension ShareLink where PreviewImage == Never, PreviewIcon == Never, Label == EmptyView /* DefaultShareLinkLabel */, Data.Element == String {
    @available(*, unavailable)
    public init(items: Data, subject: Text? = nil, message: Text? = nil) {
        fatalError()
    }

    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, items: Data, subject: Text? = nil, message: Text? = nil) {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, items: Data, subject: Text? = nil, message: Text? = nil) {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload public init<S>(_ title: S, items: Data, subject: Text? = nil, message: Text? = nil) where S : StringProtocol {
        fatalError()
    }

    @available(*, unavailable)
    public init(_ title: Text, items: Data, subject: Text? = nil, message: Text? = nil) {
        fatalError()
    }
}

extension ShareLink where PreviewImage == Never, PreviewIcon == Never, Label == Text /* DefaultShareLinkLabel */ {
    public init(item: URL, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<URL> {
        self.data = item.absoluteString
        self.subject = subject
        self.message = message
        self.label = nil
    }

    public init(item: String, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<String> {
        self.data = item
        self.subject = subject
        self.message = message
        self.label = nil
    }

    public init(_ titleKey: LocalizedStringKey, item: URL, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<URL> {
        self.data = item.absoluteString
        self.subject = subject
        self.message = message
        self.label = Text(titleKey)
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, item: URL, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<URL> {
        self.data = item.absoluteString
        self.subject = subject
        self.message = message
        self.label = Text(titleResource)
    }

    public init(_ titleKey: LocalizedStringKey, item: String, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<String> {
        self.data = item
        self.subject = subject
        self.message = message
        self.label = Text(titleKey)
    }

    @_disfavoredOverload public init(_ titleResource: AndroidLocalizedStringResource, item: String, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<String> {
        self.data = item
        self.subject = subject
        self.message = message
        self.label = Text(titleResource)
    }

    @_disfavoredOverload public init<S>(_ title: S, item: URL, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<URL>, S : StringProtocol {
        self.data = item.absoluteString
        self.subject = subject
        self.message = message
        self.label = Text(title)
    }

    @_disfavoredOverload public init<S>(_ title: S, item: String, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<String>, S : StringProtocol {
        self.data = item
        self.subject = subject
        self.message = message
        self.label = Text(title)
    }

    public init(_ title: Text, item: URL, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<URL> {
        self.data = item.absoluteString
        self.subject = subject
        self.message = message
        self.label = title
    }

    public init(_ title: Text, item: String, subject: Text? = nil, message: Text? = nil) where Data == CollectionOfOne<String> {
        self.data = item
        self.subject = subject
        self.message = message
        self.label = title
    }
}
