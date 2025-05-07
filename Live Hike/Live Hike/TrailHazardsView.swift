import SwiftUI

struct TrailHazardsView: View {
    let trail: Trail
    @State private var selectedTab = 0  
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            List {
                Image(trail.mapImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding(.bottom)

                ForEach(trail.hazards) { hazard in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(hazard.type)
                                .font(.headline)
                            Spacer()
                            Text(hazard.severity)
                                .font(.subheadline)
                                .foregroundColor(severityColor(hazard.severity))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(severityColor(hazard.severity).opacity(0.2))
                                .cornerRadius(8)
                        }

                        Text(hazard.description)
                            .font(.body)

                        HStack {
                            Image(systemName: "clock")
                            Text(hazard.reportedDate)
                            Spacer()
                            Text(hazard.status)
                                .foregroundColor(.green)
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 6)
                }
            }
            .tabItem {
                Label("Hazards", systemImage: "exclamationmark.triangle")
            }
            .tag(0)
            
            WrongTurnPinsView()
                .tabItem {
                    Label("Navigation Help", systemImage: "arrow.triangle.turn.up.right.diamond")
                }
                .tag(1)
        }
        
        .navigationTitle(trail.name)
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
