import SwiftUI

struct SignUpScreen: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var authScreenModel: AuthScreenModel
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 40)
            
            AuthHeaderView()
                .padding(.bottom, 20)
            
            AuthTextField(type: .email, text: $authScreenModel.email)
            
            let usernameInputType = AuthTextField.InputType.custom("Kullanıcı Adı", "person")
            AuthTextField(type: usernameInputType, text: $authScreenModel.username)
            
            AuthTextField(type: .password, text: $authScreenModel.password)
            
            signUpButton()
            
            backButton()
                .padding(.top, 8)
            
            Spacer()
        }
        .padding()
        .background(Color.blue)
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
    }
    
    private func signUpButton() -> some View {
        Button {
            Task {
                await authScreenModel.handleSignUp()
            }
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
        .disabled(authScreenModel.disableSignUpButton)
    }
    
    private func backButton() -> some View {
        Button {
            dismiss()
        } label: {
            Text("Zaten bir hesabın var mı? Giriş Yap")
                .font(.subheadline)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    SignUpScreen(authScreenModel: AuthScreenModel())
}
