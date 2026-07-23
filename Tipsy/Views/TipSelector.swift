import SwiftUI

// Tip picker. Replaces the segmented control, which shrank the percentages to
// caption size. The fourth segment turns into a field for any other percent.
struct TipSelector: View {
    @Environment(TipsyStore.self) private var store
    var focus: FocusState<CalculatorField?>.Binding
    @Namespace private var highlight

    var body: some View {
        HStack(spacing: 4) {
            // MARK: - Segments
            ForEach(TipOption.allCases) { option in
                segment(for: option)
            }
        }
        .padding(Metrics.controlInset)
        .background(Capsule().fill(Color.billBackground))
        .sensoryFeedback(.selection, trigger: store.tipOption)
        .onChange(of: store.customTipText) { _, typed in
            let sanitized = BillFormat.sanitizedTip(typed)
            if sanitized != typed { store.customTipText = sanitized }
        }
    }

    // The custom segment hosts a live field once picked, so it cannot sit
    // inside a Button, which would swallow the taps meant for the caret.
    @ViewBuilder
    private func segment(for option: TipOption) -> some View {
        let isSelected = store.tipOption == option

        if option == .custom, isSelected {
            customField
                .frame(width: Metrics.customSegmentWidth, height: Metrics.controlHeight)
                .background(selection)
        } else {
            Button {
                select(option)
            } label: {
                label(for: option, isSelected: isSelected)
                    .frame(height: Metrics.controlHeight)
                    // Presets share what is left over equally. The custom
                    // segment keeps its own width so its label fits whole.
                    .frame(maxWidth: option == .custom ? nil : .infinity)
                    .frame(width: option == .custom ? Metrics.customSegmentWidth : nil)
                    .background { if isSelected { selection } }
            }
            .buttonStyle(.plain)
            .contentShape(.capsule)
        }
    }

    private func label(for option: TipOption, isSelected: Bool) -> some View {
        // The word carries the meaning. An icon here read as decoration and
        // gave no hint that the segment accepts a typed percent.
        Text(option == .custom ? customLabel : option.label)
            .font(.system(size: Metrics.controlFont, weight: isSelected ? .semibold : .regular))
            .foregroundStyle(isSelected ? Color.billBackground : Color.brand)
            .lineLimit(1)
    }

    // Keeps the word until a percent is actually set, then shows that percent
    // so the segment reports its own value like the presets do.
    private var customLabel: String {
        store.customTipText.isEmpty ? TipOption.custom.label : "\(store.customTipText)%"
    }

    private var customField: some View {
        @Bindable var store = store

        return HStack(spacing: 1) {
            // MARK: - Digits
            // A hidden copy of the digits sizes the field to its content, so
            // the number and the percent sign stay centered as one unit. A
            // fixed width field left the digits pinned to one side.
            Text(sizingText)
                .hidden()
                .overlay {
                    TextField("", text: $store.customTipText)
                        .multilineTextAlignment(.center)
                        .focused(focus, equals: .tip)
                        .keyboardType(.numberPad)
                }
                .overlay {
                    // A real placeholder renders in system grey, which is
                    // nearly unreadable on the green pill.
                    if store.customTipText.isEmpty {
                        Text(sizingText)
                            .foregroundStyle(Color.billBackground.opacity(0.45))
                            .allowsHitTesting(false)
                    }
                }

            // MARK: - Percent Sign
            Text("%")
        }
        .font(.system(size: Metrics.controlFont, weight: .semibold))
        .foregroundStyle(Color.billBackground)
        .tint(Color.billBackground)
    }

    // Tracks the digits exactly so the percent sign sits tight against them.
    // Padding this out to a fixed two digits left a gap after a single digit.
    // Only the empty state borrows a width, to place its placeholder.
    private var sizingText: String {
        store.customTipText.isEmpty ? "00" : store.customTipText
    }

    private var selection: some View {
        Capsule()
            .fill(Color.brand)
            .matchedGeometryEffect(id: "tip", in: highlight)
    }

    private func select(_ option: TipOption) {
        withAnimation(.snappy(duration: 0.25)) { store.tipOption = option }
        focus.wrappedValue = option == .custom ? .tip : nil
    }
}

#Preview {
    @Previewable @FocusState var focus: CalculatorField?

    TipSelector(focus: $focus)
        .environment(TipsyStore())
        .padding()
        .background(Color.settingsBackground)
}
