// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0

@frozen public struct Transaction {
    @inlinable public init() {
    }

    public init(animation: Animation?) {
        self.animation = animation
    }

    public var animation: Animation?

    @available(*, unavailable)
    public subscript<K>(key: K.Type) -> K.Value where K : TransactionKey {
        fatalError()
    }
}

extension Transaction {
    @available(*, unavailable)
    public var isContinuous: Bool {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }
}

extension Transaction {
    @available(*, unavailable)
    public var scrollTargetAnchor: UnitPoint? {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }
}

extension Transaction {
    @available(*, unavailable)
    public var scrollPositionUpdatePreservesVelocity: Bool {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }
}

extension Transaction {
    @available(*, unavailable)
    public var scrollContentOffsetAdjustmentBehavior: ScrollContentOffsetAdjustmentBehavior {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }
}

extension Transaction {
    @available(*, unavailable)
    public var disablesAnimations: Bool {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }
}

extension Transaction {
    @available(*, unavailable)
    public mutating func addAnimationCompletion(criteria: AnimationCompletionCriteria = .logicallyComplete, _ completion: @escaping () -> Void) {
        fatalError()
    }
}

extension Transaction {
    @available(*, unavailable)
    public var tracksVelocity: Bool {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }
}

public protocol TransactionKey {
    associatedtype Value

    static var defaultValue: Self.Value { get }
}

@available(*, unavailable)
public func withTransaction<Result>(_ transaction: Transaction, _ body: () throws -> Result) rethrows -> Result {
    fatalError()
}

@available(*, unavailable)
public func withTransaction<R, V>(_ keyPath: WritableKeyPath<Transaction, V>, _ value: V, _ body: () throws -> R) rethrows -> R {
    fatalError()
}
