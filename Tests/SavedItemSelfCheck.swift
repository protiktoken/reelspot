import Foundation

@main
struct SavedItemSelfCheck {
    static func main() {
        let route = [
            MapLocation(latitude: -37.7661, longitude: 144.9924),
            MapLocation(latitude: -37.7649, longitude: 144.9940)
        ]
        let item = SavedItem(
            title: "Merri Creek picnic walk",
            kind: .activity,
            subtitle: "Walk · Melbourne",
            sourceName: "Facebook Reels",
            savedBy: "You",
            status: .ready,
            route: route
        )

        precondition(item.attributionText == "Saved by You · Facebook Reels")
        precondition(item.route?.count == 2)
    }
}
