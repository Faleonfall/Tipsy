import SwiftUI

extension Color {
    static let brand = Color(red: 0, green: 0.690, blue: 0.420)
    static let brandMuted = Color(red: 0.310, green: 0.678, blue: 0.443)
    static let billBackground = Color(red: 0.973, green: 1, blue: 0.992)
    static let settingsBackground = Color(red: 0.843, green: 0.976, blue: 0.923)
    static let caption = Color(red: 0.584, green: 0.604, blue: 0.600)
}

// Full width action button used by Calculate and Recalculate. Capsule and
// height match the tip and split pills so the pane reads as one control set.
struct BrandButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: Metrics.controlFont, weight: .semibold))
            .foregroundStyle(Color.billBackground)
            .frame(maxWidth: .infinity)
            .frame(height: Metrics.controlHeight + 2 * Metrics.controlInset)
            .background(Capsule().fill(Color.brand))
            .opacity(configuration.isPressed ? 0.85 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.snappy(duration: 0.2), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == BrandButtonStyle {
    static var brand: BrandButtonStyle { BrandButtonStyle() }
}

// Caption above each control group.
struct ControlLabel: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.system(size: Metrics.captionFont))
            .foregroundStyle(Color.caption)
    }
}
