import Foundation

struct Hazard: Identifiable, Codable {
    let id = UUID()
    let type: String
    let severity: String
    let description: String
    let reportedDate: String  
    let status: String
    let trailName: String
}


struct WrongTurnPin: Identifiable, Codable {
    var id = UUID()
    let description: String
    let landmarks: String
    let latitude: Double
    let longitude: Double
    let createdAt = Date()
}
