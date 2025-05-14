import SwiftUI
import CoreLocation

struct CreateWrongTurnPinView: View {
    let trail: Trail
    
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
                    //.background(Color(red: 0.259, green: 0.494, blue: 0.486)) // #427E7C
                    .foregroundColor(Color(red: 0.259, green: 0.494, blue: 0.486))
                    .disabled(description.isEmpty || landmarks.isEmpty || locationManager.location == nil)
                }
            }
            .navigationTitle("Mark Wrong Turn")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color(red: 0.259, green: 0.494, blue: 0.486))
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
            landmarks: landmarks,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        
        PinStorage.shared.addPin(pin)
        showingSuccess = true
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    
    private let mockLocation = CLLocation(latitude: 37.7749, longitude: -122.4194) // San Francisco
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location updated: \(locations)")
        location = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        //print("Authorization status: \(authorizationStatus.rawValue)")
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            //print("Location access granted")
            manager.startUpdatingLocation()
        case .denied, .restricted:
            //print("Location access denied")
            #if DEBUG
            self.location = mockLocation
            //print("Using mock location for testing")
            #endif
        case .notDetermined:
            //print("Location authorization not determined yet")
            manager.requestWhenInUseAuthorization()
            #if DEBUG
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if self.location == nil {
                    self.location = self.mockLocation
                    //print("Using mock location for testing")
                }
            }
            #endif
        @unknown default:
            break
        }
    }
}
