import Foundation
import SwiftUI

class AuthManager: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false
    
    // Keys for UserDefaults
    private let userKey = "currentUser"
    private let authKey = "isAuthenticated"
    
    // In a real app, these would be stored securely
    private var users: [String: User] = [:]
    
    init() {
        // Load saved state
        if let userData = UserDefaults.standard.data(forKey: userKey),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            self.currentUser = user
            self.isAuthenticated = UserDefaults.standard.bool(forKey: authKey)
        }
    }
    
    private func saveState() {
        if let user = currentUser,
           let userData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(userData, forKey: userKey)
            UserDefaults.standard.set(isAuthenticated, forKey: authKey)
        } else {
            UserDefaults.standard.removeObject(forKey: userKey)
            UserDefaults.standard.set(false, forKey: authKey)
        }
    }
    
    func signIn(email: String, password: String) {
        // For demo purposes, we'll just create a mock user
        // In a real app, this would validate against a backend
        if let existingUser = users[email] {
            self.currentUser = existingUser
        } else {
            let user = User(email: email, name: email.split(separator: "@").first?.description ?? "User")
            self.currentUser = user
            self.users[email] = user
        }
        self.isAuthenticated = true
        saveState()
    }
    
    func signUp(email: String, password: String, name: String) {
        // For demo purposes, we'll just create a new user
        // In a real app, this would create an account on the backend
        let user = User(email: email, name: name)
        self.users[email] = user
        self.currentUser = user
        self.isAuthenticated = true
        saveState()
    }
    
    func signOut() {
        self.currentUser = nil
        self.isAuthenticated = false
        saveState()
    }
}
