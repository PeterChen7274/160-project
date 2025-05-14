import SwiftUI

import Foundation

struct Hazard: Identifiable {
    let id = UUID()
    let type: String
    let severity: String
    let description: String
    let reportedDate: String
    let status: String
    let trailName: String
    
    enum CodingKeys: String, CodingKey {
        case id, type, severity, description, reportedDate, status, trailName
    }
}


struct TrailHazardsView: View {
    let trail: Trail
    @ObservedObject var trailStore: TrailStore
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Hazards List
            List {
                VStack(spacing: 15) {
                    Image(trail.mapImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .padding(.bottom)
                        .accessibilityLabel("Trail map for \(trail.name)")
                        .accessibilityHint("Shows the trail route and location")
                    
                    NavigationLink(destination: HikeView(trail: trail, trailStore: trailStore)) {
                        HStack {
                            Image(systemName: "figure.hiking")
                                .accessibilityHidden(true)
                            Text("Start Hike")
                                .font(.headline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.259, green: 0.494, blue: 0.486))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .accessibilityLabel("Start Hike")
                    .accessibilityHint("Double tap to start hiking this trail")
                }
                .listRowInsets(EdgeInsets())
                .padding(.horizontal)
                
                ForEach(trail.hazards) { hazard in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(hazard.type)
                                .font(.headline)
                                .accessibilityAddTraits(.isHeader)
                            Spacer()
                            Text(hazard.severity)
                                .font(.subheadline)
                                .foregroundColor(severityColor(hazard.severity))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(severityColor(hazard.severity).opacity(0.2))
                                .cornerRadius(8)
                                .accessibilityLabel("Severity: \(hazard.severity)")
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("\(hazard.type) - \(hazard.severity) severity")
                        
                        Text(hazard.description)
                            .font(.body)
                            .accessibilityLabel("Description: \(hazard.description)")
                        
                        HStack {
                            Image(systemName: "clock")
                                .accessibilityHidden(true)
                            Text(hazard.reportedDate)
                            Spacer()
                            Text(hazard.status)
                                .foregroundColor(.green)
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Reported \(hazard.reportedDate), Status: \(hazard.status)")
                    }
                    .padding(.vertical, 6)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Hazard: \(hazard.type). \(hazard.description). Reported \(hazard.reportedDate). Status: \(hazard.status)")
                }
            }
            .tabItem {
                Label("Hazards", systemImage: "exclamationmark.triangle.fill")
            }
            .tag(0)
            
            // Trail Info
            VStack(alignment: .leading, spacing: 20) {
                Image(trail.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15) {
                    InfoRow(title: "Location", value: trail.location, icon: "location.fill")
                    InfoRow(title: "Difficulty", value: trail.difficulty, icon: "figure.hiking")
                    InfoRow(title: "Length", value: trail.length, icon: "ruler")
                    InfoRow(title: "Elevation", value: trail.elevation, icon: "arrow.up.right")
                }
                .padding()
                
                Spacer()
                
                // Logo - make sure it's visible at the bottom
//                Image("logo")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 40, height: 40)  // Adjust size to fit
//                    .padding(.bottom, 20)  // Add padding if necessary
//                    .accessibilityLabel("Live Hike Logo")
            }
            .tabItem {
                Label("Info", systemImage: "info.circle.fill")
            }
            .tag(1)
        }
        .navigationTitle("\(trail.name) Hazards")
        .accessibilityLabel("Hazards for \(trail.name)")
    }

    private func severityColor(_ severity: String) -> Color {
        switch severity.lowercased() {
        case "high": return .red
        case "medium": return .orange
        case "low": return .yellow
        default: return .gray
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .bold()
        }
    }
}


#Preview {
    NavigationView {
        SearchTrailsView()
    }
}
