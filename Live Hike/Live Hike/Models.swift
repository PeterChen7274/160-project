import Foundation

struct Hazard: Identifiable, Codable {
    let id = UUID()
    let type: String
    let severity: String
    let description: String
    let reportedDate: String  
    let status: String
    let trailName: String
    let userId: String
}

