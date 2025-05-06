import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var isOffTrail: Bool = false
    @Published var distanceFromTrail: Double = 0
    
    private var trailCoordinates: [CLLocationCoordinate2D] = []
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
            checkIfOffTrail(userLocation: location)
        }
    }
    
    func setTrailCoordinates(coordinates: [CLLocationCoordinate2D]) {
        self.trailCoordinates = coordinates
    }
    
    private func checkIfOffTrail(userLocation: CLLocation) {
        // Skip if no trail coordinates are set
        if trailCoordinates.isEmpty {
            return
        }
        
      
        var minDistance = Double.greatestFiniteMagnitude
        
        for coordinate in trailCoordinates {
            let trailPoint = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let distance = userLocation.distance(from: trailPoint)
            minDistance = min(minDistance, distance)
        }
        
        // If we're more than 50 meters from the trail, consider off trail
        self.distanceFromTrail = minDistance
        self.isOffTrail = minDistance > 50
    }
}
