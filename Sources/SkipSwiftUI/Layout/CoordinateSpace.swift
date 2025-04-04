// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception

public enum CoordinateSpace : Equatable, Hashable {
    case global
    case local
    case named(AnyHashable)
}

extension CoordinateSpace {
    public var isGlobal: Bool {
        switch self {
        case .global:
            return true
        default:
            return false
        }
    }

    public var isLocal: Bool {
        switch self {
        case .local:
            return true
        default:
            return false
        }
    }

    // For bridging
    var identifier: Int {
        switch self {
        case .global:
            return 0
        case .local:
            return 1
        case .named(_):
            return 2
        }
    }
}

public protocol CoordinateSpaceProtocol {
    var coordinateSpace: CoordinateSpace { get }
}

public struct NamedCoordinateSpace : CoordinateSpaceProtocol, Equatable {
    private let name: AnyHashable

    init(_ name: AnyHashable) {
        self.name = name
    }

    public var coordinateSpace: CoordinateSpace {
        return .named(name)
    }
}

extension CoordinateSpaceProtocol where Self == NamedCoordinateSpace {
    public static func named(_ name: some Hashable) -> NamedCoordinateSpace {
        return NamedCoordinateSpace(name)
    }
}

public struct LocalCoordinateSpace : CoordinateSpaceProtocol {
    public init() {
    }

    public var coordinateSpace: CoordinateSpace {
        return .local
    }
}

extension CoordinateSpaceProtocol where Self == LocalCoordinateSpace {
    public static var local: LocalCoordinateSpace {
        return LocalCoordinateSpace()
    }
}

public struct GlobalCoordinateSpace : CoordinateSpaceProtocol {
    public init() {
    }

    public var coordinateSpace: CoordinateSpace {
        return .global
    }
}

extension CoordinateSpaceProtocol where Self == GlobalCoordinateSpace {
    public static var global: GlobalCoordinateSpace {
        return GlobalCoordinateSpace()
    }
}

extension CoordinateSpaceProtocol where Self == NamedCoordinateSpace {
    public static func scrollView(axis: Axis) -> Self {
        return named("_scrollView_axis_\(axis.rawValue)_")
    }

    @available(*, unavailable)
    public static var scrollView: NamedCoordinateSpace {
        return named("_scrollView_")
    }
}
