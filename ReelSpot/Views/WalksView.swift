import SwiftUI

struct WalksView: View {
    @EnvironmentObject private var model: AppModel

    private var walks: [SavedItem] {
        model.walkItems
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                intro

                if walks.isEmpty {
                    EmptyStateView(
                        title: "No walks saved yet",
                        message: "Share a scenic walk or hike into ReelSpot and it will appear here.",
                        systemImage: ActivityCategory.walk.systemImage
                    )
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(walks) { walk in
                            NavigationLink(value: walk.id) {
                                walkCard(walk)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Walks")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: UUID.self) { id in
            if let item = model.item(withID: id) {
                ItemDetailView(item: item)
            }
        }
        .task {
            await model.load()
        }
    }

    private var intro: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Move a little, discover a lot", systemImage: ActivityCategory.walk.systemImage)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.blue)
            Text("Walks to try together")
                .font(.title2.bold())
            Text("Saved walking ideas with a starting point, time, and distance when the reel gives us enough detail.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private func walkCard(_ walk: SavedItem) -> some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack(alignment: .top, spacing: 12) {
                ItemGlyph(kind: walk.kind)
                VStack(alignment: .leading, spacing: 4) {
                    Text(walk.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(walk.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                StatusPill(status: walk.status)
            }

            HStack(spacing: 16) {
                if let distance = walk.distance {
                    Label(distance, systemImage: "point.topleft.down.to.point.bottomright.curvepath")
                }
                if let duration = walk.duration {
                    Label(duration, systemImage: "clock")
                }
                if let difficulty = walk.difficulty {
                    Label(difficulty, systemImage: "figure.walk")
                }
            }
            .font(.caption.weight(.medium))
            .foregroundStyle(.secondary)

            if let address = walk.address {
                Label(address, systemImage: "mappin.and.ellipse")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct WalksView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WalksView()
        }
        .environmentObject(AppModel())
    }
}
