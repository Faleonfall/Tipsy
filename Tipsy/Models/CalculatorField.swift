import Foundation

// The focusable fields on the calculator. One focus state for all three keeps
// dismissal in a single place instead of a bool per field.
enum CalculatorField: Hashable {
    case bill
    case tip
    case split
}
