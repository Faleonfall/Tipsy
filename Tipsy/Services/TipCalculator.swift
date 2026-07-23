import Foundation

// Pure bill arithmetic. No UI dependency so it stays testable.
enum TipCalculator {
    static let splitRange = 2...25
    static let defaultSplit = 2

    // The share each person owes once the tip is added and the bill is split.
    // A non positive bill or split yields zero rather than a NaN.
    static func perPerson(bill: Double, tipPercent: Int, split: Int) -> Double {
        guard bill > 0, split > 0 else { return 0 }
        return bill * (1 + Double(tipPercent) / 100) / Double(split)
    }

    // Pulls a typed or stepped head count back inside the allowed range.
    static func clampSplit(_ value: Int) -> Int {
        min(max(value, splitRange.lowerBound), splitRange.upperBound)
    }
}
