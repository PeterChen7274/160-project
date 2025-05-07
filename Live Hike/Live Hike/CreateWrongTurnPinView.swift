import SwiftUI
import CoreLocation

struct CreateWrongTurnPinView: View {
    @State private var description = ""
    @State private var showingSuccess = false
    let trail: Trail
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Location Details") {
                    if let location = locationManager.location {
                        Text("Current location will be used")
                            .foregroundColor(.secondary)
                    } else {
                        Text("Waiting for location...")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("What's confusing here?") {
                    TextField("Describe the confusing part of the trail", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section {
                    Button("Save Pin") {
                        savePin()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .disabled(description.isEmpty || locationManager.location == nil)
                }
            }
            .navigationTitle("Mark Wrong Turn")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Pin Created", isPresented: $showingSuccess) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Thank you for helping other hikers stay on trail!")
            }
        }
    }
    
    private func savePin() {
        guard let location = locationManager.location else { return }
        
        let pin = WrongTurnPin(
            description: description,
            trailId: trail.id.uuidString,
            landmarks: "",
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        
        PinStorage.shared.addPin(pin)
        showingSuccess = true
    }
}

