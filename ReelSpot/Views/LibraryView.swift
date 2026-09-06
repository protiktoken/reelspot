import SwiftUI

struct LibraryView: View {
    @EnvironmentObject private var model: AppModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                filterBar

                if model.isLoading && model.items.isEmpty {
                    LoadingStateView()
                } else if model.filteredItems.isEmpty {
                    EmptyStateView(
                        title: "Nothing matches",
                        message: "Try another search or clear the current filter.",
                        systemImage: "line.3.horizontal.decrease.circle"
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
        .navigationTitle("Library")
        .searchable(text: $model.searchText, prompt: "Search places and recipes")
        .navigationDestination(for: UUID.self) { id in
            if let item = model.item(withID: id) {
                ItemDetailView(item: item)
            }
        }
        .task {
            await model.load()
        }
    }

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(
                    title: "Everything",
                    systemImage: "square.grid.2x2",
                    isSelected: model.selectedKind == nil
                ) {
                    model.selectedKind = nil
                    model.selectedActivityCategory = nil
                }

                ForEach(SavedItemKind.allCases) { kind in
                    FilterChip(
                        title: kind.title,
                        systemImage: kind.systemImage,
                        isSelected: model.selectedKind == kind
                    ) {
                        model.selectedKind = kind
                        model.selectedActivityCategory = nil
                    }
                }

                FilterChip(
                    title: "Walks",
                    systemImage: ActivityCategory.walk.systemImage,
                    isSelected: model.selectedActivityCategory == .walk
                ) {
                    model.selectedKind = .activity
                    model.selectedActivityCategory = .walk
                }
            }
            .padding(.vertical, 2)
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LibraryView()
        }
        .environmentObject(AppModel())
    }
}
