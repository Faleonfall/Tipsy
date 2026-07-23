import SwiftUI

// Two stacked panes, as in the original layout: bill entry on white above,
// tip and split controls on mint below.
struct CalculatorView: View {
    @Environment(TipsyStore.self) private var store
    @FocusState private var focus: CalculatorField?

    var body: some View {
        @Bindable var store = store

        VStack(spacing: 0) {
            // MARK: - Bill Entry
            BillPane(focus: $focus)

            // MARK: - Tip And Split
            SettingsPane(focus: $focus)
        }
        .background(Color.billBackground)
        .contentShape(.rect)
        .onTapGesture { focus = nil }
        .toolbar {
            // Every field uses a pad with no return key, so dismissal needs
            // an explicit control above the keyboard.
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { focus = nil }
                    .font(.body.weight(.semibold))
            }
        }
        .onChange(of: focus) { previous, _ in
            if previous == .tip { store.normalizeCustomTip() }
        }
        .fullScreenCover(isPresented: $store.isShowingResults) {
            ResultsView()
        }
    }
}

#Preview {
    CalculatorView()
        .environment(TipsyStore())
}
