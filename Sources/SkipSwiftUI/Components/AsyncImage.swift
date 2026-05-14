// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipUI

public struct AsyncImage<Content> where Content : View {
    private let url: URL?
    private let scale: CGFloat
    private let content: ((AsyncImagePhase) -> Content)?

    public init(url: URL?, scale: CGFloat = 1) where Content == Image {
        self.url = url
        self.scale = scale
        self.content = nil
    }

    public init<I, P>(url: URL?, scale: CGFloat = 1, @ViewBuilder content: @escaping (Image) -> I, @ViewBuilder placeholder: @escaping () -> P) where Content == AnyView /* _ConditionalContent<I, P> */, I : View, P : View {
        self.init(url: url, scale: scale, transaction: Transaction()) { phase in
            switch phase {
            case .empty:
                if let image = phase.image {
                    ZStack {
                        Color.clear // Showing a placeholder here prevents layout shift if the image is 0x0 on the first frame
                        image
                    }
                } else {
                    placeholder()
                }
            case .failure:
                placeholder()
            case .success(let image):
                content(image)
            }
        }
    }

    public init(url: URL?, scale: CGFloat = 1, transaction: Transaction = Transaction(), @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.scale = scale
        self.content = content
    }
}

extension AsyncImage {
    public func renderingMode(_ renderingMode: Image.TemplateRenderingMode?) -> AsyncImage {
        return AsyncImage(
            url: self.url,
            scale: self.scale,
            renderingMode: renderingMode,
            content: self.content
        )
    }
    
    private init(url: URL?, scale: CGFloat, renderingMode: Image.TemplateRenderingMode?, content: ((AsyncImagePhase) -> Content)?) {
        self.url = url
        self.scale = scale
        self.content = content
    }
}

extension AsyncImage : View {
    public typealias Body = Never
}

extension AsyncImage : SkipUIBridging {
    public var Java_view: any SkipUI.View {
        let factory: ((SkipUI.AsyncImageBridgedContentArguments) -> any SkipUI.View)?
        if let content {
            factory = { args in
                let phase: AsyncImagePhase
                if let error = args.error {
                    phase = .failure(error)
                } else if let image = args.image {
                    let imageSpec = ImageSpec(.java(image))
                    let image = Image(spec: imageSpec)
                    if args.isEmpty {
                        phase = .empty(image)
                    } else {
                        phase = .success(image)
                    }
                } else {
                    phase = .empty(nil)
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
    case empty(Image?)
    case success(Image)
    case failure(any Error)

    public var image: Image? {
        switch self {
        case .success(let image):
            return image
        case .empty(let image):
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
