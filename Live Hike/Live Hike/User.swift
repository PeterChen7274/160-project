import Foundation

struct User: Codable {
    var id: String
    var email: String
    var name: String
    var joinedDate: Date
    var completedHikes: Int
    var hikerLevel: String
    var badges: [String]
    
    init(id: String = UUID().uuidString, email: String, name: String) {
        self.id = id
        self.email = email
        self.name = name
        self.joinedDate = Date()
        self.completedHikes = 0
        self.hikerLevel = "EXPERT" 
        self.badges = ["mountains", "camping", "steeprock"] 
    }
}
