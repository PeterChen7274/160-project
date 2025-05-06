import Foundation
import CoreLocation

struct WrongTurnPin: Identifiable, Codable {
    var id = UUID()
    let trailId: String
    let latitude: Double
    let longitude: Double
    let description: String
    let landmarks: String
    var imageURLs: [String] = []
    let createdAt: Date = Date()
    let userId: String
    var reportCount: Int = 0
    var isActive: Bool = true
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
