import SwiftUI

struct InboxView: View {
    @EnvironmentObject private var model: AppModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                header

                if model.isLoading && model.items.isEmpty {
                    LoadingStateView()
                } else if let errorMessage = model.errorMessage, model.items.isEmpty {
                    ContentUnavailableView {
                        Label("Something went wrong", systemImage: "wifi.exclamationmark")
                    } description: {
                        Text(errorMessage)
                    } actions: {
                        Button("Try again") {
                            Task { await model.refresh() }
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 240)
                } else if model.filteredItems.isEmpty {
                    EmptyStateView(
                        title: "No saved ideas yet",
                        message: "Share a reel into ReelSpot and your collection will start here.",
                        systemImage: "tray"
                    )
                } else {
                    LazyVStack(spacing: 0) {
                        ForEach(model.filteredItems) { item in
                            NavigationLink(value: item.id) {
                                SavedItemRow(item: item)
                            }
                            .buttonStyle(.plain)
                            Divider()
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Your ideas")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $model.searchText, prompt: "Search saved reels")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gearshape")
                }
                .accessibilityLabel("Settings")
            }
        }
        .navigationDestination(for: UUID.self) { id in
            if let item = model.item(withID: id) {
                ItemDetailView(item: item)
            } else {
                ContentUnavailableView("Item unavailable", systemImage: "questionmark.folder")
            }
        }
        .refreshable {
            await model.refresh()
        }
        .task {
            await model.load()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("A little memory of things to eat, cook, and do together.")
                .font(.title3.weight(.medium))
                .foregroundStyle(.secondary)

            HStack(spacing: 10) {
                summaryPill(count: model.items.count, label: "saved", color: .orange)
                if model.needsReviewCount > 0 {
                    summaryPill(count: model.needsReviewCount, label: "to review", color: .purple)
                }
            }
        }
    }

    private func summaryPill(count: Int, label: String, color: Color) -> some View {
        HStack(spacing: 5) {
            Text("\(count)")
                .font(.headline)
            Text(label)
                .font(.subheadline)
        }
        .foregroundStyle(color)
        .padding(.horizontal, 11)
        .padding(.vertical, 8)
        .background(color.opacity(0.12), in: Capsule())
    }
}

struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            InboxView()
        }
        .environmentObject(AppModel())
    }
}
