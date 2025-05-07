
// //
// //  Untitled.swift
// //  Live Hike
// //
// //  Created by Fatou Bintou Dieye on 5/6/25.
// //

// import SwiftUI

// struct MyReportsView: View {
//     @State private var myHazards: [Hazard] = []
//     @State private var myPins: [WrongTurnPin] = []
//     @State private var isLoading = true
//     @State private var showingDeleteAlert = false
//     @State private var itemToDelete: ReportItem?
    
//     @State private var showSwipeHint = false
//     @State private var isSwipingBack = false
    
//     enum ReportItem: Identifiable {
//         case hazard(Hazard)
//         case pin(WrongTurnPin)
        
//         var id: UUID {
//             switch self {
//             case .hazard(let hazard): return hazard.id
//             case .pin(let pin): return pin.id
//             }
//         }
//     }
    
//     var body: some View {
//         NavigationStack {
//             Group {
//                 if isLoading {
//                     ProgressView("Loading your reports...")
//                 } else if myHazards.isEmpty && myPins.isEmpty {
//                     VStack(spacing: 20) {
//                         Image(systemName: "exclamationmark.triangle")
//                             .font(.system(size: 60))
//                             .foregroundColor(.gray)
                        
//                         Text("No Reports Yet")
//                             .font(.title2)
                        
//                         Text("Your hazard reports and wrong turn pins will appear here")
//                             .multilineTextAlignment(.center)
//                             .foregroundColor(.secondary)
//                             .padding(.horizontal)
//                     }
//                     .padding()
//                 } else {
//                     List {
//                         if !myHazards.isEmpty {
//                             Section("Hazard Reports") {
//                                 ForEach(myHazards) { hazard in
//                                     HazardReportRow(hazard: hazard)
//                                         .swipeActions {
//                                             Button(role: .destructive) {
//                                                 itemToDelete = .hazard(hazard)
//                                                 showingDeleteAlert = true
//                                             } label: {
//                                                 Label("Delete", systemImage: "trash")
//                                             }
//                                         }
//                                 }
//                             }
//                         }
                        
//                         if !myPins.isEmpty {
//                             Section("Wrong Turn Pins") {
//                                 ForEach(myPins) { pin in
//                                     WrongTurnReportRow(pin: pin)
//                                         .swipeActions {
//                                             Button(role: .destructive) {
//                                                 itemToDelete = .pin(pin)
//                                                 showingDeleteAlert = true
//                                             } label: {
//                                                 Label("Delete", systemImage: "trash")
//                                             }
//                                         }
//                                 }
//                             }
//                         }
//                     }
//                 }
//             }
//             .navigationTitle("My Reports")
//             .onAppear {
//                 loadReports()
//             }
//             .refreshable {
//                 loadReports()
//             }
//             .alert("Delete Report?", isPresented: $showingDeleteAlert) {
//                 Button("Cancel", role: .cancel) {}
//                 Button("Delete", role: .destructive) {
//                     deleteReport()
//                 }
//             } message: {
//                 Text("This will permanently remove your report. Other hikers will no longer see this information.")
//             }
//         }
//     }
    
//     private func loadReports() {
//         isLoading = true
//         myHazards = HazardStorage.shared.getUserHazards()
//         myPins = PinStorage.shared.getUserPins()
//         isLoading = false
//     }
    
//     private func deleteReport() {
//         guard let item = itemToDelete else { return }
        
//         switch item {
//         case .hazard(let hazard):
//             HazardStorage.shared.deleteHazard(withId: hazard.id)
//             myHazards.removeAll { $0.id == hazard.id }
//         case .pin(let pin):
//             PinStorage.shared.deletePin(withId: pin.id)
//             myPins.removeAll { $0.id == pin.id }
//         }
//     }
// }

// struct HazardReportRow: View {
//     let hazard: Hazard
    
//     var body: some View {
//         VStack(alignment: .leading, spacing: 4) {
//             HStack {
//                 Text(hazard.type)
//                     .font(.headline)
//                 Spacer()
//                 Text(hazard.severity)
//                     .font(.caption)
//                     .padding(4)
//                     .background(severityColor.opacity(0.2))
//                     .foregroundColor(severityColor)
//                     .cornerRadius(4)
//             }
            
//             Text(hazard.description)
//                 .font(.subheadline)
//                 .lineLimit(2)
            
//             Text(hazard.trailName)
//                 .font(.caption)
//                 .foregroundColor(.secondary)
            
//             Text("Reported \(hazard.reportedDate)")
//                 .font(.caption2)
//                 .foregroundColor(.secondary)
//         }
//         .padding(.vertical, 4)
//     }
    
//     var severityColor: Color {
//         switch hazard.severity.lowercased() {
//         case "high": return .red
//         case "medium": return .orange
//         case "low": return .yellow
//         default: return .gray
//         }
//     }
// }

// struct WrongTurnReportRow: View {
//     let pin: WrongTurnPin
    
//     var body: some View {
//         VStack(alignment: .leading, spacing: 4) {
//             Text("Wrong Turn")
//                 .font(.headline)
            
//             Text(pin.description)
//                 .font(.subheadline)
//                 .lineLimit(2)
            
            
//             Text("Reported \(pin.createdAt, style: .relative)")
//                 .font(.caption)
//                 .foregroundColor(.secondary)
//         }
//         .padding(.vertical, 4)
//     }
// }
