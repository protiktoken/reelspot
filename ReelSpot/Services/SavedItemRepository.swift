import Foundation

protocol SavedItemRepository: Sendable {
    func loadItems() async throws -> [SavedItem]
}

struct MockSavedItemRepository: SavedItemRepository, Sendable {
    func loadItems() async throws -> [SavedItem] {
        try await Task.sleep(nanoseconds: 250_000_000)
        return Self.items
    }

    private static let items: [SavedItem] = [
        SavedItem(
            title: "Ria Ayam Penyet",
            kind: .place,
            subtitle: "Indonesian · Richmond",
            sourceName: "Instagram",
            sourceURL: URL(string: "https://www.instagram.com/"),
            savedBy: "Mia",
            status: .ready,
            tags: ["date night", "spicy"],
            address: "Richmond, VIC",
            coordinate: MapLocation(latitude: -37.8183, longitude: 144.9987),
            evidence: [
                Evidence(source: "Caption", text: "Hidden Indonesian comfort food in Richmond."),
                Evidence(source: "User note", text: "She said we have to try the sambal.", isUserProvided: true)
            ]
        ),
        SavedItem(
            title: "15-minute chilli crisp noodles",
            kind: .recipe,
            subtitle: "Quick dinner · 15 min",
            sourceName: "TikTok",
            sourceURL: URL(string: "https://www.tiktok.com/"),
            savedBy: "You",
            status: .ready,
            tags: ["under 30 min", "noodles"],
            duration: "15 min",
            evidence: [
                Evidence(source: "Description", text: "The easiest chilli crisp noodles for a weeknight dinner.")
            ]
        ),
        SavedItem(
            title: "Moon Cruller",
            kind: .place,
            subtitle: "Doughnuts · Fitzroy",
            sourceName: "YouTube Shorts",
            sourceURL: URL(string: "https://www.youtube.com/"),
            savedBy: "Mia",
            status: .needsReview,
            tags: ["sweet", "weekend"],
            address: "Fitzroy, VIC",
            evidence: [
                Evidence(source: "Description", text: "A tiny doughnut shop hiding behind the market."),
                Evidence(source: "Comment", text: "Do you mean the Fitzroy or Brunswick location?")
            ]
        ),
        SavedItem(
            title: "Merri Creek picnic walk",
            kind: .activity,
            subtitle: "Walk · Melbourne",
            sourceName: "Facebook Reels",
            sourceURL: URL(string: "https://www.facebook.com/"),
            savedBy: "You",
            status: .processing,
            tags: ["outdoors", "free"],
            address: "Merri Creek, VIC"
        ),
        SavedItem(
            title: "Gochujang butter beans",
            kind: .recipe,
            subtitle: "Pantry dinner · 25 min",
            sourceName: "Instagram",
            sourceURL: URL(string: "https://www.instagram.com/"),
            savedBy: "You",
            status: .ready,
            tags: ["vegetarian", "under 30 min"],
            duration: "25 min",
            evidence: [
                Evidence(source: "Caption", text: "Creamy gochujang butter beans with toasted bread.")
            ]
        )
    ]
}
