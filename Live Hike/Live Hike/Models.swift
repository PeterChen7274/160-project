import Foundation

struct Hazard: Identifiable, Codable {
    let id: UUID
    let type: String
    let severity: String
    let description: String
    let reportedDate: String  
    let status: String
    let trailName: String
    let userId: String

    init(id: UUID = UUID(), type: String, severity: String, description: String, 
         reportedDate: String, status: String, trailName: String, userId: String) {
        self.id = id
        self.type = type
        self.severity = severity
        self.description = description
        self.reportedDate = reportedDate
        self.status = status
        self.trailName = trailName
        self.userId = userId
    }
}

