// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import Observation
import SkipBridge

public final class ObservationProbeMount {
    private let box: any ObservationProbeMountBox

    public init() {
        if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
            self.box = ObservableObservationProbeMountBox()
        } else {
            self.box = UnsupportedObservationProbeMountBox()
        }
    }

    public func setCount(_ count: Int) {
        self.box.setCount(count)
    }

    public func renderedText() -> String {
        "count: \(self.box.count)"
    }
}

private protocol ObservationProbeMountBox: AnyObject {
    var count: Int { get }
    func setCount(_ count: Int)
}

private final class UnsupportedObservationProbeMountBox: ObservationProbeMountBox {
    var count: Int { 0 }
    func setCount(_ count: Int) {}
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
private final class ObservableObservationProbeMountBox: ObservationProbeMountBox {
    private let model = ObservationProbeModel()

    var count: Int {
        self.model.count
    }

    func setCount(_ count: Int) {
        self.model.count = count
    }
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
@Observable
private final class ObservationProbeModel {
    var count = 0
}
