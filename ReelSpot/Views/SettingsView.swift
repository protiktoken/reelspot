import SwiftUI

struct SettingsView: View {
    @AppStorage("appearance") private var appearance = AppearanceOption.system.rawValue

    private var selectedAppearance: Binding<AppearanceOption> {
        Binding {
            AppearanceOption(rawValue: appearance) ?? .system
        } set: { newValue in
            appearance = newValue.rawValue
        }
    }

    var body: some View {
        Form {
            Section {
                Picker("Appearance", selection: selectedAppearance) {
                    ForEach(AppearanceOption.allCases) { option in
                        Label(option.title, systemImage: option.systemImage)
                            .tag(option)
                    }
                }
                .pickerStyle(.inline)
            } header: {
                Text("Appearance")
            } footer: {
                Text("System follows the appearance setting on your iPhone.")
            }

            Section("About this build") {
                LabeledContent("Data source", value: "Mock collection")
                LabeledContent("Front-end slice", value: "B-01")
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
        }
        .preferredColorScheme(.dark)
    }
}
