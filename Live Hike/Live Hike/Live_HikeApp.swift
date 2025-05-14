//
//  Live_HikeApp.swift
//  Live Hike
//
//  Created by Rahul Pothi Vinoth on 4/23/25.
//

import SwiftUI

@main
struct Live_HikeApp: App {
    @StateObject private var authManager = AuthManager()
    
    var body: some Scene {
        WindowGroup {
            LandingView()
                .environmentObject(authManager)
        }
    }
}
