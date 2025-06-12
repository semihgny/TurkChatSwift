
import SwiftUI
import PhotosUI

struct SettingsTabScreen: View {
    @State private var searchText = ""
    @State private var isSignOutAlertPresented = false
    @StateObject private var viewModel: SettingsTabViewModel
    
    private let currentUser: UserItem
    
    init(_ currentUser: UserItem) {
        self.currentUser = currentUser
        self._viewModel = StateObject(wrappedValue: SettingsTabViewModel(currentUser))
    }
    
    var body: some View {
        NavigationStack {
            List {
                SettingsHeaderView(viewModel, currentUser)
                
                Section {
                    Button {
                        isSignOutAlertPresented = true
                    } label: {
                        SettingsItemView(item: .logout)
                    }
                }
            }
            .navigationTitle("Ayarlar")
            
            .toolbar {
                TrailingNavItem()
            }
            
            .alert(isPresent: $viewModel.showSuccessHUD, view: viewModel.successHUDView)
            .alert("Profilinizi Güncelleyin", isPresented: $viewModel.showUserInfoEditor) {
                TextField("Kullanıcı Adı", text: $viewModel.name)
                TextField("Durum", text: $viewModel.bio)
                Button("Güncelle") {
                    viewModel.updateUsernameBio()
                }
                Button("İptal", role: .cancel) { }
            } message: {
                Text("Yeni kullanıcı adınızı ve durumunuzu girin")
            }
            .alert("Çıkış yapmak istediğinizden emin misiniz?", isPresented: $isSignOutAlertPresented) {
                Button("İptal", role: .cancel) { }
                Button("Çıkış Yap", role: .destructive) {
                    Task {
                        try? await AuthManager.shared.signOut()
                    }
                }
            }
        }
    }
}

extension SettingsTabScreen {
    @ToolbarContentBuilder
    private func TrailingNavItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Kaydet") {
            }
            .bold()
            .disabled(viewModel.disableSaveButton)
        }
    }
}


private struct SettingsHeaderView: View {
    private let currentUser: UserItem
    @ObservedObject private var viewModel: SettingsTabViewModel
    
    init(_ viewModel: SettingsTabViewModel, _ currentUser: UserItem) {
        self.viewModel = viewModel
        self.currentUser = currentUser
    }
    
    var body: some View {
        Section {
            HStack {
              
                
                userInfoTextView()
                    .onTapGesture {
                        viewModel.showUserInfoEditor = true
                    }
            }
            
        }
    }
    
    @ViewBuilder
    private func profileImageView() -> some View {
       
    }
    
    private func userInfoTextView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(currentUser.username)
                    .font(.title2)
                
                Spacer()
                
                // QR simgesi kullanıcının isteği üzerine kaldırıldı
            }
            
            Text(currentUser.bioUnwrapped)
                .foregroundStyle(.gray)
                .font(.callout)
        }
        .lineLimit(1)
    }
}

#Preview {
    SettingsTabScreen(.placeholder)
}
