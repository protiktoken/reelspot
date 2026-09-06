import MapKit
import SwiftUI

struct MapHomeView: View {
    @EnvironmentObject private var model: AppModel
    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        ZStack(alignment: .bottom) {
            Map(position: $cameraPosition) {
                ForEach(model.confirmedPlaces) { item in
                    if let coordinate = item.coordinate {
                        Marker(item.title, coordinate: CLLocationCoordinate2D(
                            latitude: coordinate.latitude,
                            longitude: coordinate.longitude
                        ))
                        .tint(.orange)
                    }
                }
            }
            .mapStyle(.standard)
            .ignoresSafeArea(edges: .bottom)

            if model.confirmedPlaces.isEmpty && !model.isLoading {
                EmptyStateView(
                    title: "Your map is waiting",
                    message: "Confirmed places from saved reels will appear here.",
                    systemImage: "map"
                )
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .padding()
            } else {
                placeStrip
            }
        }
        .navigationTitle("Map")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await model.load()
        }
    }

    private var placeStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(model.confirmedPlaces) { item in
                    NavigationLink(value: item.id) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(item.title)
                                .font(.subheadline.weight(.semibold))
                                .lineLimit(1)
                            Text(item.subtitle)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 13)
                        .padding(.vertical, 11)
                        .frame(width: 180, alignment: .leading)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .navigationDestination(for: UUID.self) { id in
            if let item = model.item(withID: id) {
                ItemDetailView(item: item)
            }
        }
    }
}

struct MapHomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MapHomeView()
        }
        .environmentObject(AppModel())
    }
}
