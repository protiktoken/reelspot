import SwiftUI

@main
struct ReelSpotApp: App {
    @StateObject private var model = AppModel()
    @AppStorage("appearance") private var appearance = AppearanceOption.system.rawValue

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(model)
                .preferredColorScheme(AppearanceOption(rawValue: appearance)?.colorScheme)
        }
    }
}
