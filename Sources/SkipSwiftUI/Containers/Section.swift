// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

public struct Section<Parent, Content, Footer> {
    private let content: Content
    private let header: Parent?
    private let footer: Footer?
}

extension Section : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.Section(bridgedContent: (content as? SkipUIBridging)?.Java_view ?? SkipUI.EmptyView(), bridgedHeader: (header as? SkipUIBridging)?.Java_view, bridgedFooter: (footer as? SkipUIBridging)?.Java_view)
    }
}

extension Section : View where Parent : View, Content : View, Footer : View {
    public typealias Body = Never
}

extension Section where Parent : View, Content : View, Footer : View {
    public init(@ViewBuilder content: () -> Content, @ViewBuilder header: () -> Parent, @ViewBuilder footer: () -> Footer) {
        self.content = content()
        self.header = header()
        self.footer = footer()
    }
}

extension Section where Parent == EmptyView, Content : View, Footer : View {
    public init(@ViewBuilder content: () -> Content, @ViewBuilder footer: () -> Footer) {
        self.content = content()
        self.header = nil
        self.footer = footer()
    }
}

extension Section where Parent : View, Content : View, Footer == EmptyView {
    public init(@ViewBuilder content: () -> Content, @ViewBuilder header: () -> Parent) {
        self.content = content()
        self.header = header()
        self.footer = nil
    }
}

extension Section where Parent == EmptyView, Content : View, Footer == EmptyView {
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
        self.header = nil
        self.footer = nil
    }
}

extension Section where Parent == Text, Content : View, Footer == EmptyView {
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.header = Text(titleKey)
        self.footer = nil
    }

    @_disfavoredOverload public init<S>(_ title: S, @ViewBuilder content: () -> Content) where S : StringProtocol {
        self.content = content()
        self.header = Text(title)
        self.footer = nil
    }
}

extension Section where Parent == Text, Content : View, Footer == EmptyView {
    @available(*, unavailable)
    public init(_ titleKey: LocalizedStringKey, isExpanded: Binding<Bool>, @ViewBuilder content: () -> Content) {
        fatalError()
    }

    @available(*, unavailable)
    @_disfavoredOverload public init<S>(_ title: S, isExpanded: Binding<Bool>, @ViewBuilder content: () -> Content) where S : StringProtocol {
        fatalError()
    }
}

extension Section where Parent : View, Content : View, Footer == EmptyView {
    @available(*, unavailable)
    public init(isExpanded: Binding<Bool>, @ViewBuilder content: () -> Content, @ViewBuilder header: () -> Parent) {
        fatalError()
    }
}

extension Section where Parent : View, Content : View, Footer : View {
    public init(header: Parent, footer: Footer, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.header = header
        self.footer = footer
    }
}

extension Section where Parent == EmptyView, Content : View, Footer : View {
    public init(footer: Footer, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.header = nil
        self.footer = footer
    }
}

extension Section where Parent : View, Content : View, Footer == EmptyView {
    public init(header: Parent, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.header = header
        self.footer = nil
    }
}

//extension Section : TableRowContent where Parent : TableRowContent, Content : TableRowContent, Footer : TableRowContent {
//
//    /// The type of value represented by this table row content.
//    public typealias TableRowValue = Content.TableRowValue
//
//    /// The type of content representing the body of this table row content.
//    public typealias TableRowBody = Never
//
//    /// Creates a section with a header and the provided section content.
//    /// - Parameters:
//    ///   - content: The section's content.
//    ///   - header: A view to use as the section's header.
//    nonisolated public init<V, H>(@TableRowBuilder<V> content: () -> Content, @ViewBuilder header: () -> H) where Parent == TableHeaderRowContent<V, H>, Footer == EmptyTableRowContent<V>, V == Content.TableRowValue, H : View
//
//    /// Creates a section with the provided section content.
//    /// - Parameters:
//    ///   - titleKey: The key for the section's localized title, which describes
//    ///     the contents of the section.
//    ///   - content: The section's content.
//    nonisolated public init<V>(_ titleKey: LocalizedStringKey, @TableRowBuilder<V> content: () -> Content) where Parent == TableHeaderRowContent<V, Text>, Footer == EmptyTableRowContent<V>, V == Content.TableRowValue
//
//    /// Creates a section with the provided section content.
//    /// - Parameters:
//    ///   - title: A string that describes the contents of the section.
//    ///   - content: The section's content.
//    nonisolated public init<V, S>(_ title: S, @TableRowBuilder<V> content: () -> Content) where Parent == TableHeaderRowContent<V, Text>, Footer == EmptyTableRowContent<V>, V == Content.TableRowValue, S : StringProtocol
//
//    /// Creates a section with the provided section content.
//    /// - Parameters:
//    ///   - content: The section's content.
//    nonisolated public init<V>(@TableRowBuilder<V> content: () -> Content) where Parent == EmptyTableRowContent<V>, Footer == EmptyTableRowContent<V>, V == Content.TableRowValue
//}
//
//@available(iOS 17.0, macOS 14.0, visionOS 1.0, *)
//@available(tvOS, unavailable)
//@available(watchOS, unavailable)
//extension Section where Parent : TableRowContent, Content : TableRowContent {
//
//    /// Creates a section with a header and the provided section content.
//    /// - Parameters:
//    ///   - isExpanded: A binding to a Boolean value that determines the section's
//    ///    expansion state (expanded or collapsed).
//    ///   - content: The section's content.
//    ///   - header: A view to use as the section's header.
//    nonisolated public init<V, H>(isExpanded: Binding<Bool>, @TableRowBuilder<V> content: () -> Content, @ViewBuilder header: () -> H) where Parent == TableHeaderRowContent<V, H>, Footer == EmptyTableRowContent<V>, V == Content.TableRowValue, H : View
//
//    /// Creates a section with the provided section content.
//    /// - Parameters:
//    ///   - titleKey: The key for the section's localized title, which describes
//    ///     the contents of the section.
//    ///   - isExpanded: A binding to a Boolean value that determines the section's
//    ///    expansion state (expanded or collapsed).
//    ///   - content: The section's content.
//    nonisolated public init<V>(_ titleKey: LocalizedStringKey, isExpanded: Binding<Bool>, @TableRowBuilder<V> content: () -> Content) where Parent == TableHeaderRowContent<V, Text>, Footer == EmptyTableRowContent<V>, V == Content.TableRowValue
//
//    /// Creates a section with the provided section content.
//    /// - Parameters:
//    ///   - title: A string that describes the contents of the section.
//    ///   - isExpanded: A binding to a Boolean value that determines the section's
//    ///    expansion state (expanded or collapsed).
//    ///   - content: The section's content.
//    nonisolated public init<V, S>(_ title: S, isExpanded: Binding<Bool>, @TableRowBuilder<V> content: () -> Content) where Parent == TableHeaderRowContent<V, Text>, Footer == EmptyTableRowContent<V>, V == Content.TableRowValue, S : StringProtocol
//}
