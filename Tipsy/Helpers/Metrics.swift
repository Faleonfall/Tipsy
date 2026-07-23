import CoreGraphics

// Shared control geometry. Every pill on the screen is built from these so the
// tip selector, split stepper, and calculate button line up as one family.
enum Metrics {
    static let controlHeight: CGFloat = 60
    static let controlInset: CGFloat = 6
    static let controlFont: CGFloat = 24

    // The custom segment holds a fixed share wide enough for the word Custom
    // and for a three digit percent, so it never shrinks its own label and
    // never resizes when the field gains or loses a digit.
    static let customSegmentWidth: CGFloat = 98
    static let captionFont: CGFloat = 22
    static let panePadding: CGFloat = 24
    static let stackSpacing: CGFloat = 16
}
