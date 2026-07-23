import SwiftUI

@main
struct TipsyApp: App {
    @State private var store = TipsyStore()

    var body: some Scene {
        WindowGroup {
            CalculatorView()
                // Tints carets, selection, and the keyboard Done button from
                // the same palette as everything else, so there is no accent
                // color asset holding a second copy of the brand green.
                .tint(Color.brand)
                .environment(store)
        }
    }
}
