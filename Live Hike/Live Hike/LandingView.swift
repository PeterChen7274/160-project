//
//  ContentView.swift
//  Live Hike
//
//  Created by Rahul Pothi Vinoth on 4/23/25.
//

import SwiftUI

struct LandingView: View {
    @StateObject private var authManager = AuthManager()
    @State private var showingLogin = false
    @State private var showingSignUp = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Image
                Image("yosemite")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        Color.black.opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                    )
                    .accessibilityHidden(true)
                
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 0) // Reduced from 60
                    
                    // Logo
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    
                    // Welcome Text
                    Text("Explore the best\ntrails around **you**. Safely.")
                        .font(.system(size: 34, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .accessibilityAddTraits(.isHeader)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 24)
                        .padding(.top, 90) // Small padding after logo
                    
                    Spacer().frame(height: 30)
                    
                    // Login/Signup buttons
                    VStack(spacing: 12) {
                        Button("Login") {
                            showingLogin = true
                        }
                        .foregroundColor(.white)
                        .frame(width: 200)
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(10)
                        
                        Button("Sign Up") {
                            showingSignUp = true
                        }
                        .foregroundColor(.white)
                        .frame(width: 200)
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(10)
                    }
                    .padding(.bottom, 140) // Increased to move buttons up more
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingLogin) {
                LoginView()
                    .environmentObject(authManager)
            }
            .sheet(isPresented: $showingSignUp) {
                SignUpView()
                    .environmentObject(authManager)
            }
            .fullScreenCover(isPresented: .init(
                get: { authManager.isAuthenticated },
                set: { _ in }
            )) {
                HomeView()
                    .environmentObject(authManager)
            }
        }
        .environmentObject(authManager)
    }
}

#Preview {
    LandingView()
}
