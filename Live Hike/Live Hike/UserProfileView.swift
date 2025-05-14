import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 25) {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 120, height: 120)
                    .overlay(
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .padding(30)
                            .foregroundColor(.white)
                    )
                    .padding(.top, 40)
                
                Text(authManager.currentUser?.name ?? "User")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                
                Text(authManager.currentUser?.email ?? "")
                    .foregroundColor(.gray)
                
                VStack(spacing: 15) {
                    ProfileInfoRow(title: "Joined", value: authManager.currentUser?.joinedDate.formatted(date: .abbreviated, time: .omitted) ?? "")
                    
                    ProfileInfoRow(title: "Completed Hikes", value: "\(authManager.currentUser?.completedHikes ?? 0)")
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    authManager.signOut()
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Sign Out")
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(15)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ProfileInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
}

#Preview {
    LandingView()
}
