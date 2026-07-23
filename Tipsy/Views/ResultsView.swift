import SwiftUI

// The per person total, shown over the calculator until the user recalculates.
struct ResultsView: View {
    @Environment(TipsyStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: Metrics.stackSpacing) {
            Spacer()

            // MARK: - Total
            ControlLabel("Total per person")

            Text(store.perPersonTotal)
                .font(.system(size: 64, weight: .bold))
                .foregroundStyle(Color.brand)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .contentTransition(.numericText())

            // MARK: - Summary
            Text(store.summary)
                .font(.system(size: Metrics.captionFont))
                .foregroundStyle(Color.brandMuted)
                .multilineTextAlignment(.center)

            Spacer()

            // MARK: - Recalculate
            Button("Recalculate") { dismiss() }
                .buttonStyle(.brand)
        }
        .padding(.horizontal, Metrics.panePadding)
        .padding(.vertical, 28)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.settingsBackground)
    }
}

#Preview {
    ResultsView()
        .environment(TipsyStore())
}
