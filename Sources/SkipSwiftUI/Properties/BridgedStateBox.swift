// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipBridge
import SkipUI

public final class BridgedStateBox<Value> {
    private let comparator: (Value, Value) -> Bool

    init(_ value: Value, comparator: @escaping (Value, Value) -> Bool) {
        self._value = Box(value)
        self.comparator = comparator
    }

    var value: Value {
        get {
            Java_stateSupport?.access()
            // Report this slot's animation provenance so an animatable modifier consuming
            // this read can decide animate-vs-snap. Skip the call entirely for un-stamped
            // slots — the common case for state never written in withAnimation. The stamp
            // lives on the shared box so it survives bridged view re-instantiation.
            if let animation = _value.lastWriteAnimation {
                StateProvenance.recordRead(animation)
            }
            return _value.value
        }
        set {
            // Stamp the slot with the active withAnimation scope's animation; a plain write
            // clears a stale stamp so later reads don't wrongly animate.
            let animation = StateProvenance.currentAnimation
            if animation != nil || _value.lastWriteAnimation != nil {
                _value.lastWriteAnimation = animation
            }
            let isUpdate = !comparator(_value.value, newValue)
            _value.value = newValue
            if isUpdate {
                Java_stateSupport?.update()
            }
        }
    }
    private var _value: Box<Value>

    private var Java_stateSupport: StateSupport?

    public func Java_initStateSupport() -> StateSupport {
        let ptr = SwiftObjectPointer.pointer(to: _value, retain: true)
        Java_stateSupport = StateSupport(valueHolder: ptr)
        return Java_stateSupport!
    }

    public func Java_syncStateSupport(_ support: StateSupport) {
        let box: Box<Value> = support.valueHolder.pointee()!
        _value = box
        Java_stateSupport = support
    }
}

//extension BridgedStateBox : @unchecked Sendable where Value : Sendable {
//}
