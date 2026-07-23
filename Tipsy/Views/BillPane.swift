import SwiftUI

// Top pane. Takes the bill total the user types.
struct BillPane: View {
    @Environment(TipsyStore.self) private var store
    var focus: FocusState<CalculatorField?>.Binding

    var body: some View {
        @Bindable var store = store

        VStack(spacing: 20) {
            // MARK: - Prompt
            ControlLabel("Enter bill total")

            // MARK: - Bill Field
            TextField("0.00", text: $store.billText)
                .font(.system(size: 56, weight: .bold))
                .foregroundStyle(Color.brand)
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .focused(focus, equals: .bill)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
        .padding(.horizontal, Metrics.panePadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.billBackground)
    }
}
