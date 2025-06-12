import SwiftUI

struct GroupPartnerPickerScreen: View {
    @ObservedObject var viewModel: ChatPartnerPickerViewModel
    @State private var searchText = ""
    
    var body: some View {
        List {
            if viewModel.showSelectedUsers {
                SelectedChatPartnerView(users: viewModel.selectedChatPartners) { kullanıcı in
                    viewModel.handleItemSelection(kullanıcı)
                }
            }
            
            Section {
                ForEach(viewModel.users) { item in
                    Button {
                        viewModel.handleItemSelection(item)
                    } label: {
                        chatPartnerRowView(item)
                    }
                }
            }
            
            if viewModel.isPaginatable {
                loadMoreUsersView()
            }
        }
        .background(Color.white) // Arka plan rengini beyaz olarak belirledim.
        .animation(.easeInOut, value: viewModel.showSelectedUsers)
       
        .navigationTitle("Katılımcı Ekle") // Başlık Türkçeye çevrildi
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            titleView()
            trailingNavItem()
        }
    }
    
    private func chatPartnerRowView(_ kullanıcı: UserItem) -> some View {
        HStack {
            ChatPartnerRowView(kullanıcı: kullanıcı) {
                Spacer()
                let isSelected = viewModel.isUserSelected(kullanıcı)
                let imageName = isSelected ? "checkmark.circle.fill" : "circle"
                let foregroundStyle = isSelected ? Color(.systemBlue) : Color(.systemGray4)
                Image(systemName: imageName)
                    .foregroundStyle(foregroundStyle)
                    .imageScale(.large)
            }
        }
        .padding(.vertical, 4) // Satır aralarına biraz boşluk ekledim
    }
    
    private func loadMoreUsersView() -> some View {
        ProgressView()
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
            .task {
                await viewModel.fetchUsers()
            }
    }
}

extension GroupPartnerPickerScreen {
    @ToolbarContentBuilder
    private func titleView() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            VStack {
                Text("Katılımcı Ekle") // Başlık Türkçeye çevrildi
                    .bold()
                    .foregroundColor(.primary) // Başlık rengi
                    .font(.title2)
                
                let count = viewModel.selectedChatPartners.count
                let maxCount = ChannelContants.maxGroupChatMembers
                
                Text("\(count)/\(maxCount) seçildi") // Seçili kullanıcı sayısı Türkçeye çevrildi
                    .foregroundColor(.gray)
                    .font(.footnote)
            }
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNavItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Sonraki") { // "Next" butonunun ismi Türkçeye çevrildi
                viewModel.navStack.append(.setUpGroupChat)
            }
            .bold()
            .foregroundColor(viewModel.selectedChatPartners.isEmpty ? .gray : .blue) // Buton rengi duruma göre değişir
            .disabled(viewModel.selectedChatPartners.isEmpty)
        }
    }
}

#Preview {
    NavigationStack {
        GroupPartnerPickerScreen(viewModel: ChatPartnerPickerViewModel())
    }
}
