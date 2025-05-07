// import SwiftUI

// struct ReportHazardView: View {
//     let trail: Trail
    
//     @State private var hazardType = ""
//     @State private var severity = "Medium" 
//     @State private var description = ""
//     @State private var showingSuccess = false
    
//     @Environment(\.dismiss) var dismiss
    
//     let severityOptions = ["Low", "Medium", "High"]
    
//     var body: some View {
//         NavigationStack {
//             Form {
//                 Section("Hazard Type") {
//                     TextField("e.g., Fallen Tree, Wildlife, Trail Damage", text: $hazardType)
//                 }
                
//                 Section("Severity") {
//                     Picker("Select Severity", selection: $severity) {
//                         ForEach(severityOptions, id: \.self) { option in
//                             Text(option)
//                         }
//                     }
//                     .pickerStyle(.segmented)
//                 }
                
//                 Section("Description") {
//                     TextField("Describe the hazard in detail", text: $description, axis: .vertical)
//                         .lineLimit(3...6)
//                 }
                
//                 Section {
//                     Button("Report Hazard") {
//                         reportHazard()
//                     }
//                     .frame(maxWidth: .infinity, alignment: .center)
//                     .disabled(hazardType.isEmpty || description.isEmpty)
//                 }
//             }
//             .navigationTitle("Report Hazard")
//             .toolbar {
//                 ToolbarItem(placement: .cancellationAction) {
//                     Button("Cancel") {
//                         dismiss()
//                     }
//                 }
//             }
//             .alert("Hazard Reported", isPresented: $showingSuccess) {
//                 Button("OK") {
//                     dismiss()
//                 }
//             } message: {
//                 Text("Thank you for helping keep other hikers safe!")
//             }
//         }
//     }
    
//     private func reportHazard() {
//         let newHazard = Hazard(
//             type: hazardType,
//             severity: severity,
//             description: description,
//             reportedDate: "Just now",
//             status: "Active",
//             trailName: trail.name,
//             userId: UserManager.shared.userId
//         )
        
//         HazardStorage.shared.addHazard(newHazard)
//         showingSuccess = true
//     }
// }
