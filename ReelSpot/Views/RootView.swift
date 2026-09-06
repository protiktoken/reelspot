import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            NavigationStack {
                InboxView()
            }
            .tabItem {
                Label("Inbox", systemImage: "tray.fill")
            }

            NavigationStack {
                MapHomeView()
            }
            .tabItem {
                Label("Map", systemImage: "map.fill")
            }

            NavigationStack {
                LibraryView()
            }
            .tabItem {
                Label("Library", systemImage: "books.vertical.fill")
            }

            NavigationStack {
                AskView()
            }
            .tabItem {
                Label("Ask", systemImage: "sparkles")
            }
        }
        .tint(.orange)
        .task {
            // The environment model is loaded by InboxView as soon as the first tab appears.
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(AppModel())
    }
}
