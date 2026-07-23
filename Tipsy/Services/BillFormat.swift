import Foundation

// Parsing what the user typed and formatting what the app shows back.
enum BillFormat {

    // Reads a typed amount. The decimal pad hands back a comma on locales that
    // use one, so both separators are accepted.
    static func amount(from text: String) -> Double? {
        let normalized = text.trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: ",", with: ".")
        guard !normalized.isEmpty else { return nil }
        return Double(normalized)
    }

    // A percent never needs a fourth digit, and the cap keeps the entry from
    // outgrowing its segment while it is being typed.
    static let maxTipDigits = 3

    // Keeps the custom field to plain digits within the digit cap. The number
    // pad already excludes letters, but a paste does not.
    static func sanitizedTip(_ text: String) -> String {
        String(text.filter(\.isNumber).prefix(maxTipDigits))
    }

    // Reads a typed tip percent, ignoring anything that is not a whole number.
    static func tipPercent(from text: String) -> Int? {
        let normalized = text.trimmingCharacters(in: .whitespaces)
        guard !normalized.isEmpty, let value = Int(normalized) else { return nil }
        return value
    }

    // A money value fixed to two decimal places, written the way the reader's
    // locale writes numbers, e.g. 56.3157 -> "56.32" or "56,32". The locale is
    // a parameter so tests do not depend on the machine running them.
    static func currency(_ value: Double, locale: Locale = .current) -> String {
        value.formatted(.number.precision(.fractionLength(2)).locale(locale))
    }

    // The line under the total, e.g. "Split between 2 people, with 10% tip."
    static func summary(split: Int, tipPercent: Int) -> String {
        "Split between \(split) people, with \(tipPercent)% tip."
    }
}
