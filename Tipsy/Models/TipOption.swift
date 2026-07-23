import Foundation

// The choices in the tip control. The presets carry their own percent, custom
// defers to whatever the user types.
enum TipOption: CaseIterable, Identifiable, Hashable {
    case none
    case ten
    case twenty
    case custom

    var id: Self { self }

    // Nil marks the option whose percent comes from the text field.
    var presetPercent: Int? {
        switch self {
        case .none: 0
        case .ten: 10
        case .twenty: 20
        case .custom: nil
        }
    }

    var label: String {
        presetPercent.map { "\($0)%" } ?? "Custom"
    }
}
