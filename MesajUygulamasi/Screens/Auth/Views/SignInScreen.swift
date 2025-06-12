import SwiftUI

struct SignInScreen: View {
    @StateObject private var authScreenModel = AuthScreenModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer(minLength: 40)
                
                AuthHeaderView()
                    .padding(.bottom, 20)
                
                AuthTextField(type: .email, text: $authScreenModel.email)
                AuthTextField(type: .password, text: $authScreenModel.password)
                
                signInButton()
                
                signUpButton()
                
                Spacer()
            }
            .padding()
            .background(Color.blue)
            .alert(isPresented: $authScreenModel.errorState.showError) {
                Alert(
                    title: Text(authScreenModel.errorState.errorMessage),
                    dismissButton: .default(Text("Tamam"))
                )
            }
        }
        .environment(\.colorScheme, .light)
    }
    
    private func signInButton() -> some View {
        Button {
            Task {
                await authScreenModel.handleSignIn()
            }
        } label: {
            Text("Giriş Yap")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
        .padding(.horizontal)
        .disabled(authScreenModel.disableSignInButton)
    }

    private func signUpButton() -> some View {
        NavigationLink {
            SignUpScreen(authScreenModel: authScreenModel)
        } label: {
            Text("Kayıt Ol")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
        .padding(.horizontal)
    }
}

#Preview {
    SignInScreen()
}
