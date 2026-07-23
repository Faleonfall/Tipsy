import Foundation
import Testing

@testable import Tipsy

struct BillFormatTests {

    @Test func amountReadsBothDecimalSeparators() {
        #expect(BillFormat.amount(from: "123.50") == 123.5)
        #expect(BillFormat.amount(from: "123,50") == 123.5)
        #expect(BillFormat.amount(from: " 42 ") == 42)
    }

    @Test func amountRejectsEmptyAndJunk() {
        #expect(BillFormat.amount(from: "") == nil)
        #expect(BillFormat.amount(from: "   ") == nil)
        #expect(BillFormat.amount(from: "abc") == nil)
    }

    @Test func tipPercentReadsWholeNumbersOnly() {
        #expect(BillFormat.tipPercent(from: "15") == 15)
        #expect(BillFormat.tipPercent(from: " 7 ") == 7)
        #expect(BillFormat.tipPercent(from: "") == nil)
        #expect(BillFormat.tipPercent(from: "12.5") == nil)
    }

    @Test func sanitizedTipCapsAtThreeDigits() {
        #expect(BillFormat.sanitizedTip("1234") == "123")
        #expect(BillFormat.sanitizedTip("18") == "18")
        #expect(BillFormat.sanitizedTip("") == "")
    }

    @Test func sanitizedTipDropsNonDigits() {
        #expect(BillFormat.sanitizedTip("1a2") == "12")
        #expect(BillFormat.sanitizedTip("12.5") == "125")
        #expect(BillFormat.sanitizedTip("abc") == "")
    }

    @Test func currencyFixesTwoDecimals() {
        let us = Locale(identifier: "en_US")
        #expect(BillFormat.currency(56.3157, locale: us) == "56.32")
        #expect(BillFormat.currency(7, locale: us) == "7.00")
    }

    @Test func currencyFollowsLocaleSeparators() {
        #expect(BillFormat.currency(56.3157, locale: Locale(identifier: "de_DE")) == "56,32")
        #expect(BillFormat.currency(56.3157, locale: Locale(identifier: "fr_FR")) == "56,32")
        #expect(BillFormat.currency(56.3157, locale: Locale(identifier: "uk_UA")) == "56,32")
    }

    @Test func currencyGroupsLargeAmountsPerLocale() {
        #expect(BillFormat.currency(1234.5, locale: Locale(identifier: "en_US")) == "1,234.50")
        #expect(BillFormat.currency(1234.5, locale: Locale(identifier: "de_DE")) == "1.234,50")
    }

    @Test func summaryNamesSplitAndTip() {
        #expect(
            BillFormat.summary(split: 2, tipPercent: 10) == "Split between 2 people, with 10% tip.")
        #expect(
            BillFormat.summary(split: 5, tipPercent: 0) == "Split between 5 people, with 0% tip.")
    }
}
