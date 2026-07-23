import SwiftUI

// Bottom pane. Tip percentage, head count, and the calculate action.
struct SettingsPane: View {
    @Environment(TipsyStore.self) private var store
    var focus: FocusState<CalculatorField?>.Binding

    var body: some View {
        VStack(spacing: Metrics.stackSpacing) {
            // MARK: - Tip
            ControlLabel("Select tip")
            TipSelector(focus: focus)

            // MARK: - Split
            ControlLabel("Choose split")
                .padding(.top, 4)
            SplitStepper(focus: focus)

            // MARK: - Calculate
            Button("Calculate") {
                focus.wrappedValue = nil
                store.calculate()
            }
            .buttonStyle(.brand)
            .padding(.top, 8)
        }
        .padding(.horizontal, Metrics.panePadding)
        .padding(.vertical, 28)
        .frame(maxWidth: .infinity)
        .background(Color.settingsBackground)
    }
}
