import Foundation

@MainActor
final class AuthScreenModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var isLoading = false
    @Published var email = ""
    @Published var password = ""
    @Published var username = ""
    @Published var errorState: (showError: Bool, errorMessage: String) = (false, "Bir hata oluştu.")

    // MARK: - Computed Properties
    
    var disableSignInButton: Bool {
        return email.isEmpty || password.isEmpty || isLoading
    }
    
    var disableSignUpButton: Bool {
        return email.isEmpty || password.isEmpty || username.isEmpty || isLoading
    }

    // MARK: - Actions

    func handleSignUp() async {
        isLoading = true
        do {
            try await AuthManager.shared.signUp(for: username, with: email, and: password)
        } catch {
            errorState.errorMessage = "Kayıt işlemi başarısız. \(error.localizedDescription)"
            errorState.showError = true
            isLoading = false
        }
    }
    
    func handleSignIn() async {
        isLoading = true
        do {
            try await AuthManager.shared.signIn(email: email, and: password)
        } catch {
            errorState.errorMessage = "Giriş işlemi başarısız. \(error.localizedDescription)"
            errorState.showError = true
            isLoading = false
        }
    }
}
