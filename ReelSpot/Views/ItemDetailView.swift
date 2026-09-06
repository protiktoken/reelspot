import SwiftUI

struct ItemDetailView: View {
    @EnvironmentObject private var model: AppModel
    @State private var isShowingReview = false

    let item: SavedItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                hero
                statusSection

                if let address = item.address {
                    detailSection(title: "Location", systemImage: "mappin.and.ellipse") {
                        Text(address)
                            .font(.body)
                        if item.isConfirmedPlace {
                            Text("Confirmed place · shown on your map")
                                .font(.caption)
                                .foregroundStyle(.green)
                        }
                    }
                }

                if let duration = item.duration {
                    detailSection(title: "Time", systemImage: "clock") {
                        Text(duration)
                    }
                }

                if !item.tags.isEmpty {
                    detailSection(title: "Tags", systemImage: "tag") {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), alignment: .leading)], alignment: .leading, spacing: 8) {
                            ForEach(item.tags, id: \.self) { tag in
                                TagPill(text: tag)
                            }
                        }
                    }
                }

                evidenceSection
                actions
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Saved idea")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingReview) {
            ReviewSheet(item: item)
                .presentationDetents([.medium, .large])
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 12) {
            ItemGlyph(kind: item.kind)
            KindPill(kind: item.kind)
            Text(item.title)
                .font(.largeTitle.bold())
            Text(item.subtitle)
                .font(.title3)
                .foregroundStyle(.secondary)
            Text("Saved by (item.savedBy) · (item.sourceName)")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
        }
    }

    private var statusSection: some View {
        HStack(spacing: 8) {
            StatusPill(status: item.status)
            if item.status == .needsReview {
                Text("Check the details before adding it to the map.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var evidenceSection: some View {
        detailSection(title: "Why ReelSpot thinks this", systemImage: "text.quote") {
            if item.evidence.isEmpty {
                Text("No caption or comment evidence has been saved yet.")
                    .foregroundStyle(.secondary)
            } else {
                VStack(alignment: .leading, spacing: 14) {
                    ForEach(item.evidence) { evidence in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(evidence.source)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(evidence.isUserProvided ? .orange : .secondary)
                            Text(evidence.text)
                                .font(.body)
                        }
                    }
                }
            }
        }
    }

    private var actions: some View {
        VStack(spacing: 10) {
            if item.status == .needsReview {
                Button {
                    isShowingReview = true
                } label: {
                    Label("Review location", systemImage: "checkmark.magnifyingglass")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
            }

            if let sourceURL = item.sourceURL {
                ShareLink(item: sourceURL) {
                    Label("Share or open original link", systemImage: "arrow.up.right.square")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private func detailSection<Content: View>(title: String, systemImage: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: systemImage)
                .font(.headline)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct ReviewSheet: View {
    @EnvironmentObject private var model: AppModel
    @Environment(\.dismiss) private var dismiss

    let item: SavedItem

    private let candidates = [
        ("Moon Cruller · Fitzroy", "Fitzroy, VIC", MapLocation(latitude: -37.7984, longitude: 144.9787)),
        ("Moon Cruller · Brunswick", "Brunswick, VIC", MapLocation(latitude: -37.7667, longitude: 144.9615))
    ]

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("The reel appears to mention more than one possible branch. Choose the place that matches the video, or leave it for later.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Section("Possible places") {
                    ForEach(candidates, id: \.0) { candidate in
                        Button {
                            model.markReviewed(item, address: candidate.1, coordinate: candidate.2)
                            dismiss()
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(candidate.0)
                                        .foregroundStyle(.primary)
                                    Text(candidate.1)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.tertiary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Review place")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Later") { dismiss() }
                }
            }
        }
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ItemDetailView(item: MockSavedItemRepository.itemsForPreview[0])
        }
        .environmentObject(AppModel())
    }
}

private extension MockSavedItemRepository {
    static var itemsForPreview: [SavedItem] {
        [
            SavedItem(
                title: "Moon Cruller",
                kind: .place,
                subtitle: "Doughnuts · Fitzroy",
                sourceName: "YouTube Shorts",
                savedBy: "Mia",
                status: .needsReview,
                tags: ["sweet", "weekend"],
                address: "Fitzroy, VIC",
                evidence: [Evidence(source: "Comment", text: "Do you mean the Fitzroy or Brunswick location?")]
            )
        ]
    }
}
