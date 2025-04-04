// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipFuse
import SkipUI

let logger: Logger = Logger(subsystem: "SkipSwiftUI", category: "SkipSwiftUI")

public protocol View {
    associatedtype Body: View
    @ViewBuilder @MainActor var body: Body { get }
}

func stubView() -> EmptyView {
    return EmptyView()
}

public extension View where Body == Never {
    var body: Never { fatalError("Never") }
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

extension Never : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        return SkipUI.EmptyView()
    }
}
