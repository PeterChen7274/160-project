import SwiftUI

struct CompletedHike: Identifiable {
    let id = UUID()
    let trailName: String
    let duration: TimeInterval
    let date: Date
    let distance: String
    let elevation: String
}

class HikeHistoryStore: ObservableObject {
    @Published var completedHikes: [CompletedHike] = [
        CompletedHike(
            trailName: "Mount Rainier Summit",
            duration: 25200, // 7 hours
            date: Date().addingTimeInterval(-86400), // Yesterday
            distance: "8.5 miles",
            elevation: "4,392 ft"
        ),
        CompletedHike(
            trailName: "Grizzly Peak Trail",
            duration: 7200, // 2 hours
            date: Date().addingTimeInterval(-172800), // 2 days ago
            distance: "4.3 miles",
            elevation: "1,200 ft"
        ),
        CompletedHike(
            trailName: "Tilden Park Lake Anza Loop",
            duration: 3600, // 1 hour
            date: Date().addingTimeInterval(-259200), // 3 days ago
            distance: "2.1 miles",
            elevation: "300 ft"
        )
    ]
    
    func addHike(_ hike: CompletedHike) {
        completedHikes.insert(hike, at: 0) // Add new hikes at the beginning
    }
}

struct HikeHistoryView: View {
    @EnvironmentObject var historyStore: HikeHistoryStore
    
    var body: some View {
        List {
            ForEach(historyStore.completedHikes) { hike in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(hike.trailName)
                            .font(.headline)
                        Spacer()
                        Text(hike.date.formatted(date: .abbreviated, time: .shortened))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Label(timeString(from: hike.duration), systemImage: "clock")
                        Spacer()
                        Label(hike.distance, systemImage: "figure.hiking")
                        Spacer()
                        Label(hike.elevation, systemImage: "arrow.up.right")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(hike.trailName) hike completed on \(hike.date.formatted(date: .long, time: .shortened)). Duration: \(timeString(from: hike.duration)). Distance: \(hike.distance). Elevation gain: \(hike.elevation)")
            }
        }
        .navigationTitle("Hike History")
        .accessibilityLabel("List of completed hikes")
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        return String(format: "%dh %dm", hours, minutes)
    }
}
