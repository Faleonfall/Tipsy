import Observation

// App-wide state. Holds what the user typed and picked, and derives the
// result strings from the services so no view does arithmetic itself.
@Observable
final class TipsyStore {
    var billText = ""
    var tipOption: TipOption = .none
    var customTipText = ""
    var split = TipCalculator.defaultSplit
    var isShowingResults = false

    // Presets answer for themselves, custom falls back to zero until the
    // field holds a number. A custom tip has no ceiling beyond its digit
    // count, since a tip larger than the bill is a real thing to enter.
    var tipPercent: Int {
        if let preset = tipOption.presetPercent { return preset }
        return BillFormat.tipPercent(from: customTipText) ?? 0
    }

    var perPersonTotal: String {
        let bill = BillFormat.amount(from: billText) ?? 0
        return BillFormat.currency(
            TipCalculator.perPerson(bill: bill, tipPercent: tipPercent, split: split))
    }

    var summary: String {
        BillFormat.summary(split: split, tipPercent: tipPercent)
    }

    var canDecreaseSplit: Bool { split > TipCalculator.splitRange.lowerBound }
    var canIncreaseSplit: Bool { split < TipCalculator.splitRange.upperBound }

    // Stepping and typing share one path so both stay inside the range.
    func adjustSplit(by delta: Int) {
        split = TipCalculator.clampSplit(split + delta)
    }

    // Rewrites the custom field to the value actually in use, so a leading
    // zero does not keep showing a percent the total never applied.
    func normalizeCustomTip() {
        guard let typed = BillFormat.tipPercent(from: customTipText) else {
            customTipText = ""
            return
        }
        customTipText = String(typed)
    }

    func calculate() {
        isShowingResults = true
    }
}
