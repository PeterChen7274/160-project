import Foundation

class PinStorage {
    static let shared = PinStorage()
    
    private let wrongTurnPinsKey = "wrongTurnPins"
    
    func savePins(_ pins: [WrongTurnPin]) {
        if let encoded = try? JSONEncoder().encode(pins) {
            UserDefaults.standard.set(encoded, forKey: wrongTurnPinsKey)
        }
    }
    
    func loadPins() -> [WrongTurnPin] {
        if let data = UserDefaults.standard.data(forKey: wrongTurnPinsKey),
           let pins = try? JSONDecoder().decode([WrongTurnPin].self, from: data) {
            return pins
        }
        return []
    }
    
    func loadPinsForTrail(trailId: String) -> [WrongTurnPin] {
        let allPins = loadPins()
        return allPins.filter { $0.trailId == trailId }
    }
    
    func addPin(_ pin: WrongTurnPin) {
        var pins = loadPins()
        pins.append(pin)
        savePins(pins)
    }
    
    func deletePin(withId id: UUID) {
        var pins = loadPins()
        pins.removeAll { $0.id == id }
        savePins(pins)
    }

    func getUserPins() -> [WrongTurnPin] {
        let allPins = loadPins()
        return allPins.filter { $0.userId == UserManager.shared.userId }
    }
}

