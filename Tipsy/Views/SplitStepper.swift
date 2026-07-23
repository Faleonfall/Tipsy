import SwiftUI

// Head count control. The count sits between its own minus and plus rather
// than across the row from a system stepper, and is typeable for large parties.
struct SplitStepper: View {
    @Environment(TipsyStore.self) private var store
    var focus: FocusState<CalculatorField?>.Binding

    // Editing buffer. Binding the field straight to the count made typing
    // insert at the caret, so entering 8 over a 3 read as 83. The buffer
    // empties on focus and shows the live count as its placeholder instead.
    @State private var draft = ""

    var body: some View {
        HStack(spacing: 0) {
            // MARK: - Decrease
            stepButton("minus", enabled: store.canDecreaseSplit) { store.adjustSplit(by: -1) }

            // MARK: - Count
            ZStack {
                TextField("", text: $draft)
                    .keyboardType(.numberPad)
                    .focused(focus, equals: .split)

                // Standing in for a placeholder, which would render the count
                // in placeholder grey and read as an empty field. It clears on
                // focus, since a full strength count beside the caret looked
                // like text that typing would append to.
                if draft.isEmpty, focus.wrappedValue != .split {
                    Text(String(store.split))
                        .contentTransition(.numericText())
                        .allowsHitTesting(false)
                }
            }
            .font(.system(size: Metrics.controlFont + 6, weight: .semibold))
            .foregroundStyle(Color.brand)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)

            // MARK: - Increase
            stepButton("plus", enabled: store.canIncreaseSplit) { store.adjustSplit(by: 1) }
        }
        .padding(Metrics.controlInset)
        .background(Capsule().fill(Color.billBackground))
        .sensoryFeedback(.selection, trigger: store.split)
        .onChange(of: focus.wrappedValue) { previous, current in
            if current == .split {
                draft = ""
            } else if previous == .split {
                commitDraft()
            }
        }
    }

    // An empty or unparsable buffer leaves the count untouched, so tapping
    // away without typing is a no op.
    private func commitDraft() {
        if let typed = Int(draft) {
            store.split = TipCalculator.clampSplit(typed)
        }
        draft = ""
    }

    private func stepButton(
        _ symbol: String, enabled: Bool, action: @escaping () -> Void
    ) -> some View {
        Button {
            focus.wrappedValue = nil
            withAnimation(.snappy(duration: 0.2)) { action() }
        } label: {
            Image(systemName: symbol)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(enabled ? Color.brand : Color.caption.opacity(0.4))
                .frame(width: Metrics.controlHeight, height: Metrics.controlHeight)
                .background(Circle().fill(Color.settingsBackground))
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
    }
}

#Preview {
    @Previewable @FocusState var focus: CalculatorField?

    SplitStepper(focus: $focus)
        .environment(TipsyStore())
        .padding()
        .background(Color.settingsBackground)
}
