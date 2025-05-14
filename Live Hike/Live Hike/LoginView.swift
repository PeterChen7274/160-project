import SwiftUI
import Combine

// Create a custom Color extension for our theme colors
extension Color {
    static let customTeal = Color(red: 0.4, green: 0.6, blue: 0.58)
}

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    @State private var keyboardHeight: CGFloat = 0
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 24) {
                        Text("Welcome Back!")
                            .font(.system(size: 32, weight: .medium))
                            .foregroundColor(.black)
                            .padding(.top, 40)
                            .padding(.bottom, 20)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .foregroundColor(Color(.systemGray))
                                .font(.system(size: 14))
                            TextField("", text: $email)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.vertical, 14)
                                .padding(.horizontal, 16)
                                .background(Color(.systemGray6).opacity(0.8))
                                .cornerRadius(10)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                                .focused($focusedField, equals: .email)
                                .submitLabel(.next)
                                .placeholder(when: email.isEmpty) {
                                    Text("Enter your email")
                                        .foregroundColor(Color(.systemGray2))
                                        .padding(.leading, 4)
                                }
                        }
                        .padding(.horizontal)
                        .disabled(isLoading)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .foregroundColor(Color(.systemGray))
                                .font(.system(size: 14))
                            SecureField("", text: $password)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.vertical, 14)
                                .padding(.horizontal, 16)
                                .background(Color(.systemGray6).opacity(0.8))
                                .cornerRadius(10)
                                .focused($focusedField, equals: .password)
                                .submitLabel(.done)
                                .placeholder(when: password.isEmpty) {
                                    Text("Enter your password")
                                        .foregroundColor(Color(.systemGray2))
                                        .padding(.leading, 4)
                                }
                        }
                        .padding(.horizontal)
                        .disabled(isLoading)
                        
                        if showError {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.system(size: 14))
                                .padding(.horizontal)
                                .padding(.top, -10)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                        
                        Spacer()
                            .frame(height: 50)
                    }
                }
                .scrollDisabled(true)
                
                Spacer()
                
                Button(action: {
                    submit()
                }) {
                    ZStack {
                        Text("Sign In")
                            .foregroundColor(.white)
                            .opacity(isLoading ? 0 : 1)
                            .font(.system(size: 17, weight: .semibold))
                        
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.customTeal.opacity(isLoading ? 0.8 : 1))
                    .cornerRadius(10)
                }
                .disabled(isLoading)
                .padding(.horizontal)
                .padding(.vertical, 20)
            }
            .onSubmit {
                switch focusedField {
                case .email:
                    focusedField = .password
                case .password:
                    submit()
                default:
                    break
                }
            }
            .background(Color.white)
            .onTapGesture {
                hideKeyboard()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        hideKeyboard()
                        dismiss()
                    }
                    .foregroundColor(.black)
                    .disabled(isLoading)
                }
            }
            .onReceive(Publishers.keyboardHeight) { height in
                withAnimation(.easeOut(duration: 0.25)) {
                    self.keyboardHeight = height
                }
            }
        }
    }
    
    private func submit() {
        hideKeyboard()
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            if validateInputs() {
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    authManager.signIn(email: email, password: password)
                    isLoading = false
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    dismiss()
                }
            } else {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
        }
    }
    
    private func hideKeyboard() {
        focusedField = nil
    }
    
    private func validateInputs() -> Bool {
        withAnimation(.easeInOut(duration: 0.2)) {
            if email.isEmpty || password.isEmpty {
                errorMessage = "Please fill in all fields"
                showError = true
                return false
            }
            
            if !email.contains("@") {
                errorMessage = "Please enter a valid email"
                showError = true
                return false
            }
            
            showError = false
            return true
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { notification -> CGFloat in
                return (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
            }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        return MergeMany([willShow, willHide])
            .eraseToAnyPublisher()
    }
}
