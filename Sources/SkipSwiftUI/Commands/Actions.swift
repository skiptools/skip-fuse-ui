// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation

@MainActor @preconcurrency public struct DismissAction : Sendable {
    let action: @MainActor () -> Void

    nonisolated init(action: @escaping @MainActor () -> Void) {
        self.action = action
    }

    @MainActor @preconcurrency public func callAsFunction() {
        action()
    }
}

public struct OpenURLAction : Sendable {
    public struct Result : Sendable {
        public static let handled = OpenURLAction.Result(identifier: 0)

        public static let discarded = OpenURLAction.Result(identifier: 1)

        public static let systemAction = OpenURLAction.Result(identifier: 2)

        public static func systemAction(_ url: URL) -> OpenURLAction.Result {
            return OpenURLAction.Result(identifier: 2, url: url)
        }

        let identifier: Int // For bridging
        let url: URL?

        init(identifier: Int, url: URL? = nil) {
            self.identifier = identifier
            self.url = url
        }
    }

    let handler: @MainActor (URL) -> OpenURLAction.Result
    let systemHandler: (@MainActor (URL) throws -> Void)?

    @MainActor @preconcurrency public init(handler: @escaping @MainActor (URL) -> OpenURLAction.Result) {
        self.handler = handler
        self.systemHandler = nil
    }

    init(handler: @escaping @MainActor (URL) -> OpenURLAction.Result, systemHandler: @escaping @MainActor (URL) throws -> Void) {
        self.handler = handler
        self.systemHandler = systemHandler
    }

    @MainActor @preconcurrency public func callAsFunction(_ url: URL) {
        callAsFunction(url, completion: { _ in })
    }

    @MainActor @preconcurrency public func callAsFunction(_ url: URL, completion: @escaping (_ accepted: Bool) -> Void) {
        let result = handler(url)
        if result.identifier == Result.handled.identifier {
            completion(true)
        } else if result.identifier == Result.discarded.identifier {
            completion(false)
        } else if result.identifier == Result.systemAction.identifier {
            if let systemHandler {
                let openURL = result.url ?? url
                do {
                    try systemHandler(openURL)
                } catch {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
}

public struct RefreshAction : @unchecked Sendable {
    let action: () async -> Void

    public func callAsFunction() async {
        await action()
    }
}
