import Foundation

class HazardStorage {
    static let shared = HazardStorage()
    
    private let userHazardsKey = "userReportedHazards"
    
    func saveHazards(_ hazards: [Hazard]) {
        if let encoded = try? JSONEncoder().encode(hazards) {
            UserDefaults.standard.set(encoded, forKey: userHazardsKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    func loadHazards() -> [Hazard] {
        if let data = UserDefaults.standard.data(forKey: userHazardsKey),
           let hazards = try? JSONDecoder().decode([Hazard].self, from: data) {
            return hazards
        }
        return []
    }
    
    func loadHazardsForTrail(trailName: String) -> [Hazard] {
        let allHazards = loadHazards()
        return allHazards.filter { $0.trailName == trailName }
    }
    
    func addHazard(_ hazard: Hazard) {
        var hazards = loadHazards()
        hazards.append(hazard)
        saveHazards(hazards)
    }
    
    func deleteHazard(withId id: UUID) {
        var hazards = loadHazards()
        hazards.removeAll { $0.id == id }
        saveHazards(hazards)
    }

    func getUserHazards() -> [Hazard] {
        let allHazards = loadHazards()
        return allHazards.filter { $0.userId == UserManager.shared.userId }
    }
}
