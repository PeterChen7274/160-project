import SwiftUI
import CoreLocation

struct CreateWrongTurnPinView: View {
    @State private var description = ""
    @State private var landmarks = ""
    @State private var showingSuccess = false
    
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
                
                Section("Landmarks to look for") {
                    TextField("Describe visible landmarks to help others", text: $landmarks, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section {
                    Button("Save Pin") {
                        savePin()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .disabled(description.isEmpty || landmarks.isEmpty || locationManager.location == nil)
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
            landmarks: landmarks,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        
        PinStorage.shared.addPin(pin)
        showingSuccess = true
    }
}

// Simple location manager to get user's location
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }
}
