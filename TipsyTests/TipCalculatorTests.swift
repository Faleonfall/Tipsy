import Testing

@testable import Tipsy

struct TipCalculatorTests {

    @Test func noTipSplitsEvenly() {
        #expect(TipCalculator.perPerson(bill: 100, tipPercent: 0, split: 4) == 25)
    }

    // Binary floating point makes 100 * 1.1 land just off 110, so the tip
    // cases compare within a tolerance rather than exactly.
    @Test func tipIsAddedBeforeSplitting() {
        #expect(abs(TipCalculator.perPerson(bill: 100, tipPercent: 10, split: 2) - 55) < 1e-9)
        #expect(abs(TipCalculator.perPerson(bill: 100, tipPercent: 20, split: 5) - 24) < 1e-9)
    }

    @Test func customPercentIsHonored() {
        #expect(abs(TipCalculator.perPerson(bill: 200, tipPercent: 15, split: 4) - 57.5) < 1e-9)
    }

    // A tip larger than the bill is legitimate, so nothing caps the percent.
    @Test func percentAboveOneHundredIsHonored() {
        #expect(abs(TipCalculator.perPerson(bill: 100, tipPercent: 150, split: 2) - 125) < 1e-9)
        #expect(abs(TipCalculator.perPerson(bill: 50, tipPercent: 999, split: 1) - 549.5) < 1e-9)
    }

    @Test func nonPositiveBillYieldsZero() {
        #expect(TipCalculator.perPerson(bill: 0, tipPercent: 20, split: 2) == 0)
        #expect(TipCalculator.perPerson(bill: -10, tipPercent: 20, split: 2) == 0)
    }

    @Test func nonPositiveSplitYieldsZero() {
        #expect(TipCalculator.perPerson(bill: 100, tipPercent: 10, split: 0) == 0)
    }

    @Test func clampPullsSplitInsideRange() {
        #expect(TipCalculator.clampSplit(0) == TipCalculator.splitRange.lowerBound)
        #expect(TipCalculator.clampSplit(999) == TipCalculator.splitRange.upperBound)
        #expect(TipCalculator.clampSplit(7) == 7)
    }
}
