// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SkipUI

/* @MainActor */ @preconcurrency public struct AsyncImage<Content> : View where Content : View {
    private let url: URL?
    private let scale: CGFloat
    private let content: ((AsyncImagePhase) -> Content)?

    nonisolated public init(url: URL?, scale: CGFloat = 1) where Content == Image {
        self.url = url
        self.scale = scale
        self.content = nil
    }

    nonisolated public init<I, P>(url: URL?, scale: CGFloat = 1, @ViewBuilder content: @escaping (Image) -> I, @ViewBuilder placeholder: @escaping () -> P) where Content == AnyView /* _ConditionalContent<I, P> */, I : View, P : View {
        self.init(url: url, scale: scale, transaction: Transaction()) { phase in
            switch phase {
            case .empty, .failure:
                placeholder()
            case .success(let image):
                content(image)
            }
        }
    }

    nonisolated public init(url: URL?, scale: CGFloat = 1, transaction: Transaction = Transaction(), @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.scale = scale
        self.content = content
    }

    public typealias Body = Never
}

extension AsyncImage : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        let factory: ((SkipUI.Image?, (any Error)?) -> any SkipUI.View)?
        if let content {
            factory = { image, error in
                let phase: AsyncImagePhase
                if image == nil && error == nil {
                    phase = .empty
                } else if let error {
                    phase = .failure(error)
                } else {
                    phase = .success(Image(spec: .init(.java(image!))))
                }
                let result = content(phase)
                return result.Java_viewOrEmpty
            }
        } else {
            factory = nil
        }
        return SkipUI.AsyncImage(scale: scale, url: url, bridgedContent: factory)
    }
}

public enum AsyncImagePhase : Sendable {
    case empty
    case success(Image)
    case failure(any Error)

    public var image: Image? {
        switch self {
        case .success(let image):
            return image
        default:
            return nil
        }
    }

    public var error: (any Error)? {
        switch self {
        case .failure(let error):
            return error
        default:
            return nil
        }
    }
}
