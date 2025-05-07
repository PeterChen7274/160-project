import Foundation
import CoreLocation

struct WrongTurnPin: Identifiable, Codable {
    var id = UUID()
    let trailId: String
    let description: String
    let landmarks: String 
    let latitude: Double
    let longitude: Double
    let createdAt = Date()
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
