
import SwiftUI

struct RootScreen: View {
    @StateObject private var viewModel = RootScreenModel()
    
    var body: some View {
        switch viewModel.authState {
        case .pending:
            ProgressView()
                .controlSize(.large)
        
        case .authenticated(let loggedInUser):
            MainTabView(loggedInUser)
            
        case .unauthenticated:
            SignInScreen()
            
        }
    }
}

#Preview {
    RootScreen()
}
