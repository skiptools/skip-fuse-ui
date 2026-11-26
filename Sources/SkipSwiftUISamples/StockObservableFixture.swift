// Copyright 2026 Skip
import SkipFuse
import SkipSwiftUI
#if SKIP_BRIDGE
// Bridged modules see Skip's `Observation` shim; reach past it to the stock module's types.
typealias StockObservable = ObservationModule.ObservableType
typealias StockObservationRegistrar = ObservationModule.ObservationRegistrarType
#else
import Observation
typealias StockObservable = Observable
typealias StockObservationRegistrar = ObservationRegistrar
#endif

/// A model that is not Skip-aware: it uses the stock `Observation` registrar directly, like a
/// type from a third-party package, so only body observation tracking can refresh views.
final class StockObservableModel: StockObservable, @unchecked Sendable {
    private let registrar = StockObservationRegistrar()

    private var _count = 0
    var count: Int {
        get { registrar.access(self, keyPath: \.count); return _count }
        set { registrar.withMutation(of: self, keyPath: \.count) { _count = newValue } }
    }

    private var _rowValue = 0
    var rowValue: Int {
        get { registrar.access(self, keyPath: \.rowValue); return _rowValue }
        set { registrar.withMutation(of: self, keyPath: \.rowValue) { _rowValue = newValue } }
    }

    private var _flag = false
    var flag: Bool {
        get { registrar.access(self, keyPath: \.flag); return _flag }
        set { registrar.withMutation(of: self, keyPath: \.flag) { _flag = newValue } }
    }
}

/// Sample: views reading a non-Skip-aware `Observable` model in a body, in lazy `ForEach` items
/// (evaluated after the body), and through a `Binding` that only the `Toggle` reads.
public struct StockObservableTestFixture: View {
    let model = StockObservableModel()

    public init() {
    }

    /// Lets the transpiled tests run the fixture with tracking off as a control.
    public static func setBodyObservationTrackingEnabled(_ enabled: Bool) {
        BodyObservationTracking.isEnabled = enabled
    }

    public var body: some View {
        VStack {
            Text("count: \(model.count)")
                .accessibilityIdentifier("stock-count")
            Button("increment") { model.count += 1 }
                .accessibilityIdentifier("stock-increment")
            Button("bump row") { model.rowValue += 1 }
                .accessibilityIdentifier("stock-bump-row")
            Button("flip flag") { model.flag.toggle() }
                .accessibilityIdentifier("stock-flip-flag")
            Toggle("flag", isOn: Binding(get: { model.flag }, set: { model.flag = $0 }))
                .accessibilityIdentifier("stock-toggle")
            ScrollView {
                LazyVStack {
                    ForEach(0..<3, id: \.self) { i in
                        Text("row \(i): \(model.rowValue)")
                            .accessibilityIdentifier("stock-row-\(i)")
                    }
                }
            }
        }
    }
}
