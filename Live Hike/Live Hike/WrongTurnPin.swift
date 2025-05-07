import Foundation
import CoreLocation

struct WrongTurnPin: Identifiable, Codable {
    var id: UUID
    let description: String
    let trailId: String
    let landmarks: String
    let latitude: Double
    let longitude: Double
    let createdAt = Date()
    let userId: String

    init(id: UUID = UUID(), description: String, trailId: String, landmarks: String,
         latitude: Double, longitude: Double, createdAt: Date = Date(), userId: String) {
        self.id = id
        self.description = description
        self.trailId = trailId
        self.landmarks = landmarks
        self.latitude = latitude
        self.longitude = longitude
        self.createdAt = createdAt
        self.userId = userId
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
