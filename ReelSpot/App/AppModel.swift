import Combine
import Foundation

@MainActor
final class AppModel: ObservableObject {
    @Published private(set) var items: [SavedItem] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published var searchText = ""
    @Published var selectedKind: SavedItemKind?
    @Published var selectedActivityCategory: ActivityCategory?

    private let repository: SavedItemRepository

    init(repository: SavedItemRepository = MockSavedItemRepository()) {
        self.repository = repository
    }

    var filteredItems: [SavedItem] {
        items.filter { item in
            let matchesKind = selectedKind == nil || item.kind == selectedKind
            let matchesActivityCategory = selectedActivityCategory == nil || item.activityCategory == selectedActivityCategory
            let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            let matchesQuery = query.isEmpty || [item.title, item.subtitle, item.sourceName, item.tags.joined(separator: " ")]
                .joined(separator: " ")
                .localizedCaseInsensitiveContains(query)
            return matchesKind && matchesActivityCategory && matchesQuery
        }
    }

    var mappedItems: [SavedItem] {
        filteredItems.filter(\.isMapped)
    }

    var walkItems: [SavedItem] {
        items.filter { $0.kind == .activity && $0.activityCategory == .walk }
    }

    var needsReviewCount: Int {
        items.filter { $0.status == .needsReview }.count
    }

    func load() async {
        guard items.isEmpty, !isLoading else { return }
        isLoading = true
        errorMessage = nil
        do {
            items = try await repository.loadItems()
        } catch {
            errorMessage = "We could not load your saved ideas."
        }
        isLoading = false
    }

    func refresh() async {
        isLoading = true
        errorMessage = nil
        do {
            items = try await repository.loadItems()
        } catch {
            errorMessage = "We could not refresh your saved ideas."
        }
        isLoading = false
    }

    func item(withID id: UUID) -> SavedItem? {
        items.first { $0.id == id }
    }

    func markReviewed(_ item: SavedItem, address: String, coordinate: MapLocation) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        let updated = SavedItem(
            id: item.id,
            title: item.title,
            kind: item.kind,
            subtitle: item.subtitle,
            sourceName: item.sourceName,
            sourceURL: item.sourceURL,
            savedBy: item.savedBy,
            savedAt: item.savedAt,
            status: .ready,
            tags: item.tags,
            address: address,
            coordinate: coordinate,
            duration: item.duration,
            activityCategory: item.activityCategory,
            distance: item.distance,
            difficulty: item.difficulty,
            evidence: item.evidence
        )
        items[index] = updated
    }
}
