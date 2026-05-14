// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipFuse
import SkipUI

let logger: Logger = Logger(subsystem: "SkipSwiftUI", category: "SkipSwiftUI")

@MainActor @preconcurrency public protocol View {
    associatedtype Body : View
    @ViewBuilder @MainActor var body: Body { get }
}

@usableFromInline func stubView() -> EmptyView {
    return EmptyView()
}

extension View where Body == Never {
    public var body: Never { fatalError("Never") }
}

extension Optional : View where Wrapped : View {
    public var body: some View {
        if let self {
            return AnyView(erasing: self.body)
        } else {
            return AnyView(erasing: EmptyView())
        }
    }
}

extension Optional : SkipUIBridging where Wrapped : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        switch self {
        case .none:
            return SkipUI.EmptyView()
        case .some(let view):
            return view.Java_view
        }
    }
}

extension Never : View {
    public typealias Body = Never
}

extension Never : SkipUIBridging, @retroactive JObjectProtocol, @retroactive JConvertible {
    public var Java_view: any SkipUI.View {
        return SkipUI.EmptyView()
    }
}
