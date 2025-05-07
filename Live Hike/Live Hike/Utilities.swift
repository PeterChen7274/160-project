//
//  Utilities.swift
//  Live Hike
//
//  Created by Fatou Bintou Dieye on 5/6/25.
//

import Foundation

struct UserManager {
    static let shared = UserManager()
    
    private let userIdKey = "localUserId"
    
    var userId: String {
        if let existingId = UserDefaults.standard.string(forKey: userIdKey) {
            return existingId
        } else {
            let newId = UUID().uuidString
            UserDefaults.standard.set(newId, forKey: userIdKey)
            return newId
        }
    }
}
