import SwiftUI

struct TrailHazardsView: View {
    let trail: Trail
    @State private var selectedTab = 0
    @State private var userReportedHazards: [Hazard] = []
    @State private var showingReportHazardSheet = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Hazards tab
            List {
                Image(trail.mapImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding(.bottom)
                
                if !trail.hazards.isEmpty || !userReportedHazards.isEmpty {
                    // Official hazards section
                    if !trail.hazards.isEmpty {
                        Section("Official Hazards") {
                            ForEach(trail.hazards) { hazard in
                                HazardRow(hazard: hazard)
                            }
                        }
                    }
                    
                    // User reported hazards section
                    if !userReportedHazards.isEmpty {
                        Section("Community Reported") {
                            ForEach(userReportedHazards) { hazard in
                                HazardRow(hazard: hazard)
                            }
                        }
                    }
                } else {
                    Text("No hazards reported for this trail")
                        .foregroundColor(.secondary)
                        .padding()
                }
                
                Button {
                    showingReportHazardSheet = true
                } label: {
                    Label("Report a Hazard", systemImage: "exclamationmark.triangle")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                }
            }
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingReportHazardSheet = true
                        }) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(Color.red)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding()
                    }
                }
            )
            .tabItem {
                Label("Hazards", systemImage: "exclamationmark.triangle")
            }
            .tag(0)
            
            // Navigation help tab with wrong turn pins
            WrongTurnPinsView(trail: trail)
                .tabItem {
                    Label("Navigation Help", systemImage: "arrow.triangle.turn.up.right.diamond")
                }
                .tag(1)
        }
        .navigationTitle(trail.name)
        .onAppear {
            loadUserReportedHazards()
        }
        .sheet(isPresented: $showingReportHazardSheet) {
            ReportHazardView(trail: trail)
                .onDisappear {
                    loadUserReportedHazards()
                }
        }
    }
    
    private func loadUserReportedHazards() {
        userReportedHazards = HazardStorage.shared.loadHazardsForTrail(trailName: trail.name)
    }
}


struct HazardRow: View {
    let hazard: Hazard
    
    var body: some View {
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
    
    private func severityColor(_ severity: String) -> Color {
        switch severity.lowercased() {
        case "high": return .red
        case "medium": return .orange
        case "low": return .yellow
        default: return .gray
        }
    }
}

