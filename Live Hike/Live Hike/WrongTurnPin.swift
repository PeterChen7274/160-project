import Foundation
import CoreLocation

struct WrongTurnPin: Identifiable, Codable {
    var id = UUID()
    let description: String
     let trailId: String
    let landmarks: String
    let latitude: Double
    let longitude: Double
    let createdAt = Date()
    let userId: String
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
