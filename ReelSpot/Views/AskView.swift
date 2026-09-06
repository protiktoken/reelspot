import SwiftUI

struct AskView: View {
    @EnvironmentObject private var model: AppModel
    @State private var question = ""
    @State private var hasAsked = false

    private let prompts = [
        "Find a quick recipe",
        "What should we try this weekend?",
        "Show me saved noodle places"
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Your saved ideas, together", systemImage: "sparkles")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.orange)
                    Text("Ask ReelSpot")
                        .font(.largeTitle.bold())
                    Text("Search the things you have saved, then turn them into a plan.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Try asking")
                        .font(.headline)
                    ForEach(prompts, id: \.self) { prompt in
                        Button {
                            question = prompt
                            hasAsked = false
                        } label: {
                            HStack {
                                Text(prompt)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 5)
                        }
                        .buttonStyle(.plain)
                    }
                }

                VStack(spacing: 0) {
                    TextField("Ask about your saved places or recipes", text: $question, axis: .vertical)
                        .lineLimit(1...4)
                        .padding(13)
                        .submitLabel(.send)
                        .onSubmit {
                            ask()
                        }

                    HStack {
                        Text("Mock search for now")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                        Spacer()
                        Button(action: ask) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.title2)
                                .foregroundStyle(question.isEmpty ? Color.secondary : Color.orange)
                        }
                        .disabled(question.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .padding(.horizontal, 13)
                    .padding(.bottom, 10)
                }
                .background(.background, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(.quaternary, lineWidth: 1)
                }

                if hasAsked {
                    responseCard
                }
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Ask")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await model.load()
        }
    }

    private var responseCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("A first answer from your library", systemImage: "sparkles")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.orange)
            Text(mockAnswer)
                .font(.body)

            if let item = model.filteredItems.first {
                NavigationLink(value: item.id) {
                    HStack {
                        ItemGlyph(kind: item.kind)
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.subheadline.weight(.semibold))
                            Text("Open saved card")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.tertiary)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .navigationDestination(for: UUID.self) { id in
            if let item = model.item(withID: id) {
                ItemDetailView(item: item)
            }
        }
    }

    private var mockAnswer: String {
        if question.localizedCaseInsensitiveContains("recipe") {
            return "You have a couple of quick recipes saved. The chilli crisp noodles are marked as 15 minutes, so they are the easiest starting point."
        }
        if question.localizedCaseInsensitiveContains("weekend") {
            return "Moon Cruller still needs a location check. Ria Ayam Penyet is ready and saved as a date-night idea."
        }
        return "I found ideas in your shared library. Once the real search service is connected, I will include evidence and map distance with every answer."
    }

    private func ask() {
        guard !question.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        hasAsked = true
    }
}

struct AskView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AskView()
        }
        .environmentObject(AppModel())
    }
}
