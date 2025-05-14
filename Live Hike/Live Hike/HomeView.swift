import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    @StateObject private var historyStore = HikeHistoryStore()
    
    var body: some View {
        NavigationView {
            VStack {
                // Background Image with gradient overlay
                Image("yosemite")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .edgesIgnoringSafeArea(.top) // Ensures the background only fills top part
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                //Color.white.opacity(0.80),
                                //Color.white.opacity(0.2)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .edgesIgnoringSafeArea(.all)
                    )

                // Content
                VStack(spacing: 0) {
                    // Welcome Text
                    Text("Welcome, ")
                        .foregroundColor(Color(red: 0.259, green: 0.494, blue: 0.486)) // #427E7C
                        .font(.system(size: 60, weight: .heavy))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .padding(.top, 20)
                    
                    Text("Arushi ")
                        .foregroundColor(Color(red: 0.259, green: 0.494, blue: 0.486)) // #427E7C
                        .font(.system(size: 60, weight: .heavy))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .padding(.top, -15)
                        .padding(.bottom, -10)
                    
                    Text("Start Exploring")
                        .foregroundColor(Color(red: 0.722, green: 0.067, blue: 0.067)) // #B81111
                        .font(.system(size: 30, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    
                    // Hiking Info Section
                    HStack (spacing: -10) {
                        VStack(spacing: 0) {
                            Text("Hiking Since")
                                .foregroundColor(Color(red: 0.259, green: 0.494, blue: 0.486)) // #427E7C
                                .font(.system(size: 25, weight: .medium))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                                .padding(.top, 10)
                            
                            Text("JAN 2025")
                                .foregroundColor(Color(red: 0, green: 0, blue: 0)) // #black
                                .font(.system(size: 20, weight: .light))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                                .padding(.top, 10)
                        }
                        
                        VStack(spacing: 0) {
                            Text("Hiker Level")
                                .foregroundColor(Color(red: 0.259, green: 0.494, blue: 0.486)) // #427E7C
                                .font(.system(size: 25, weight: .medium))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                                .padding(.top, 10)
                            
                            Text("EXPERT")
                                .foregroundColor(Color(red: 0, green: 0, blue: 0)) // #black
                                .font(.system(size: 20, weight: .light))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                                .padding(.top, 10)
                        }
                    }
                    Spacer()
                        .frame(height: 20)
                    
                    VStack(spacing: 10) {
                        Text("Badges Collected")
                            .foregroundColor(Color(red: 0.259, green: 0.494, blue: 0.486)) // #427E7C
                            .font(.system(size: 25, weight: .medium))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                            .padding(.top, 10)
                        
                        HStack (spacing: 0) {
                            
                            Image("badge1")
                            Image("badge2")
                            Image("badge3")
                        }.frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Spacer()
                        .frame(height: 70)
                    
                    // Main Buttons Section
                    VStack(spacing: 10) {
                        NavigationLink(destination: SearchTrailsView()) {
                            HStack {
                                Text("Search Trails")
                                    .font(.headline)
                                Image(systemName: "arrow.right")
                                    .accessibilityHidden(true)
                            }
                            .padding()
                            .frame(width: 300)
                            .background(Color(red: 0.259, green: 0.494, blue: 0.486)) // #427E7C
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .accessibilityLabel("Search Trails")
                        .accessibilityHint("Double tap to search for hiking trails")
                        
                        NavigationLink(destination: WildlifeScannerView()) {
                            HStack {
                                Image(systemName: "camera.viewfinder")
                                    .accessibilityHidden(true)
                                Text("Wildlife Scanner")
                                    .font(.headline)
                            }
                            .padding()
                            .frame(width: 300)
                            .background(Color(red: 0.259, green: 0.494, blue: 0.486)) // #427E7C
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .accessibilityLabel("Wildlife Scanner")
                        .accessibilityHint("Double tap to scan and identify wildlife")
                        
                        NavigationLink(destination: HikeHistoryView()) {
                            HStack {
                                Image(systemName: "clock.arrow.circlepath")
                                    .accessibilityHidden(true)
                                Text("Hike History")
                                    .font(.headline)
                            }
                            .padding()
                            .frame(width: 300)
                            .background(Color(red: 0.259, green: 0.494, blue: 0.486)) // #427E7C
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .accessibilityLabel("Hike History")
                        .accessibilityHint("Double tap to view your completed hikes")
                    }
                    
                    Spacer()
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                }
                .background(Color.white.opacity(0.7)) // Ensures the content is not overlapping the background
                .cornerRadius(30)
                .padding(.top, 50)
            }
            .navigationBarHidden(true)
        } .environmentObject(historyStore)
    }
}


#Preview {
    HomeView()
}
