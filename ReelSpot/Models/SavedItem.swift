import Foundation

enum SavedItemKind: String, CaseIterable, Identifiable, Sendable {
    case place
    case recipe
    case activity
    case unknown

    var id: String { rawValue }

    var title: String {
        switch self {
        case .place: "Eat"
        case .recipe: "Cook"
        case .activity: "Visit"
        case .unknown: "Idea"
        }
    }

    var systemImage: String {
        switch self {
        case .place: "fork.knife"
        case .recipe: "frying.pan"
        case .activity: "figure.hiking"
        case .unknown: "link"
        }
    }
}

enum ProcessingStatus: String, Sendable {
    case processing
    case ready
    case needsReview
    case failed

    var title: String {
        switch self {
        case .processing: "Processing"
        case .ready: "Ready"
        case .needsReview: "Needs review"
        case .failed: "Could not process"
        }
    }

    var systemImage: String {
        switch self {
        case .processing: "clock.arrow.circlepath"
        case .ready: "checkmark.circle.fill"
        case .needsReview: "questionmark.circle.fill"
        case .failed: "exclamationmark.triangle.fill"
        }
    }
}

enum ActivityCategory: String, CaseIterable, Identifiable, Sendable {
    case walk
    case hike
    case beach
    case museum
    case market
    case other

    var id: String { rawValue }

    var title: String {
        switch self {
        case .walk: "Walk"
        case .hike: "Hike"
        case .beach: "Beach"
        case .museum: "Museum"
        case .market: "Market"
        case .other: "Other"
        }
    }

    var systemImage: String {
        switch self {
        case .walk: "figure.walk"
        case .hike: "figure.hiking"
        case .beach: "beach.umbrella"
        case .museum: "building.columns"
        case .market: "storefront"
        case .other: "sparkles"
        }
    }
}

struct MapLocation: Hashable, Sendable {
    let latitude: Double
    let longitude: Double
}

struct Evidence: Identifiable, Hashable, Sendable {
    let id: UUID
    let source: String
    let text: String
    let isUserProvided: Bool

    init(id: UUID = UUID(), source: String, text: String, isUserProvided: Bool = false) {
        self.id = id
        self.source = source
        self.text = text
        self.isUserProvided = isUserProvided
    }
}

struct SavedItem: Identifiable, Hashable, Sendable {
    let id: UUID
    let title: String
    let kind: SavedItemKind
    let subtitle: String
    let sourceName: String
    let sourceURL: URL?
    let savedBy: String
    let savedAt: Date
    let status: ProcessingStatus
    let tags: [String]
    let address: String?
    let coordinate: MapLocation?
    let duration: String?
    let activityCategory: ActivityCategory?
    let distance: String?
    let difficulty: String?
    let route: [MapLocation]?
    let evidence: [Evidence]

    var attributionText: String {
        "Saved by \(savedBy) · \(sourceName)"
    }

    var isMapped: Bool {
        coordinate != nil && status == .ready
    }

    init(
        id: UUID = UUID(),
        title: String,
        kind: SavedItemKind,
        subtitle: String,
        sourceName: String,
        sourceURL: URL? = nil,
        savedBy: String,
        savedAt: Date = .now,
        status: ProcessingStatus,
        tags: [String] = [],
        address: String? = nil,
        coordinate: MapLocation? = nil,
        duration: String? = nil,
        activityCategory: ActivityCategory? = nil,
        distance: String? = nil,
        difficulty: String? = nil,
        route: [MapLocation]? = nil,
        evidence: [Evidence] = []
    ) {
        self.id = id
        self.title = title
        self.kind = kind
        self.subtitle = subtitle
        self.sourceName = sourceName
        self.sourceURL = sourceURL
        self.savedBy = savedBy
        self.savedAt = savedAt
        self.status = status
        self.tags = tags
        self.address = address
        self.coordinate = coordinate
        self.duration = duration
        self.activityCategory = activityCategory
        self.distance = distance
        self.difficulty = difficulty
        self.route = route
        self.evidence = evidence
    }
}
