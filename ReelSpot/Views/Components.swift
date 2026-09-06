import SwiftUI

struct ItemGlyph: View {
    let kind: SavedItemKind

    var body: some View {
        Image(systemName: kind.systemImage)
            .font(.headline)
            .foregroundStyle(.white)
            .frame(width: 42, height: 42)
            .background(kind.tint, in: RoundedRectangle(cornerRadius: 13, style: .continuous))
    }
}

struct KindPill: View {
    let kind: SavedItemKind

    var body: some View {
        Label(kind.title, systemImage: kind.systemImage)
            .font(.caption.weight(.semibold))
            .foregroundStyle(kind.tint)
            .padding(.horizontal, 9)
            .padding(.vertical, 5)
            .background(kind.tint.opacity(0.12), in: Capsule())
    }
}

struct StatusPill: View {
    let status: ProcessingStatus

    var body: some View {
        Label(status.title, systemImage: status.systemImage)
            .font(.caption.weight(.medium))
            .foregroundStyle(status.tint)
    }
}

struct TagPill: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.horizontal, 9)
            .padding(.vertical, 5)
            .background(.quaternary, in: Capsule())
    }
}

struct SavedItemRow: View {
    let item: SavedItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ItemGlyph(kind: item.kind)

            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                    Spacer(minLength: 8)
                    Text(item.savedAt, format: .dateTime.month(.abbreviated).day())
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }

                Text(item.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    Text(item.sourceName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("·")
                        .foregroundStyle(.tertiary)
                    Text("Saved by (item.savedBy)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 8) {
                    StatusPill(status: item.status)
                    ForEach(item.tags.prefix(2), id: \.self) { tag in
                        TagPill(text: tag)
                    }
                }
            }
        }
        .padding(.vertical, 5)
    }
}

struct FilterChip: View {
    let title: String
    let systemImage: String?
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
            }
            .font(.subheadline.weight(.medium))
            .foregroundStyle(isSelected ? .white : .primary)
            .padding(.horizontal, 13)
            .padding(.vertical, 8)
            .background(isSelected ? Color.accentColor : Color.secondary.opacity(0.12), in: Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct LoadingStateView: View {
    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
            Text("Loading your ideas…")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 220)
    }
}

struct EmptyStateView: View {
    let title: String
    let message: String
    let systemImage: String

    var body: some View {
        ContentUnavailableView(title, systemImage: systemImage, description: Text(message))
            .frame(maxWidth: .infinity, minHeight: 240)
    }
}

extension SavedItemKind {
    var tint: Color {
        switch self {
        case .place: .orange
        case .recipe: .green
        case .activity: .blue
        }
    }
}

extension ProcessingStatus {
    var tint: Color {
        switch self {
        case .processing: .orange
        case .ready: .green
        case .needsReview: .purple
        case .failed: .red
        }
    }
}
