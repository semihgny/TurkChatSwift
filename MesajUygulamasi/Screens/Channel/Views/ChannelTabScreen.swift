import SwiftUI

struct ChannelTabScreen: View {
    @State private var searchText = ""
    @StateObject private var viewModel: ChannelTabViewModel
    
    init(_ currentUser: UserItem) {
        self._viewModel = StateObject(wrappedValue: ChannelTabViewModel(currentUser))
    }
    
    var body: some View {
        NavigationStack(path: $viewModel.navRoutes) {
            VStack {
                List {
                    
                    ForEach(viewModel.channels) { kanal in
                        Button {
                            viewModel.navRoutes.append(.chatRoom(kanal))
                        } label: {
                            ChannelItemView(kanal: kanal)
                        }
                    }
                    
                    // Footer bilgisi korundu
                    inboxFooterView()
                        .listRowSeparator(.hidden)
                }
                .navigationTitle("Sohbetler")
               
                .listStyle(.plain)
                .background(BackgroundColorView()) // Arka plan otomatik beyaz/siyah
                .toolbar {
                    leadingNavItems()
                    trailingNavItem()
                }
                .navigationDestination(for: ChannelTabRoutes.self) { route in
                    destinationView(for: route)
                }
                .sheet(isPresented: $viewModel.showChatPartnerPickerView) {
                    ChatPartnerPickerScreen(onCreate: viewModel.onNewChannelCreation)
                }
                .navigationDestination(isPresented: $viewModel.navigateToChatRoom) {
                    if let newChannel = viewModel.newChannel {
                        ChatRoomScreen(kanal: newChannel)
                    }
                }
                
                // Alt kısmı sabit yapacak yeni sohbet butonu
                newChatButton()
                    .padding(.bottom, 20)
                    .padding(.horizontal, 30)
            }
        }
    }
}

extension ChannelTabScreen {
    
    @ViewBuilder
    private func destinationView(for route: ChannelTabRoutes) -> some View {
        switch route {
        case .chatRoom(let kanal):
            ChatRoomScreen(kanal: kanal)
        }
    }
    
    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            // Sohbet seçme butonu kaldırıldı
            EmptyView()
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNavItem() -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            // Kamera butonu kaldırıldı
            // AI butonu kaldırıldı
            // Sadece yeni sohbet butonu korundu
            EmptyView() // Kamerayı kaldırdık
        }
    }
    
    private func newChatButton() -> some View {
        Button {
            viewModel.showChatPartnerPickerView = true
        } label: {
            Text("Sohbet Başlat")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(Color.blue)
                .cornerRadius(25) // Yuvarlak buton
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
                .font(.title3)
        }
    }
    
    private func inboxFooterView() -> some View {
        HStack {
            Image(systemName: "lock.fill")
            
            Text("Kişisel mesajlarınız uçtan uca şifrelenmiştir.")
                .foregroundColor(.gray)
        }
        .font(.caption)
        .padding(.horizontal)
    }
    
    private func BackgroundColorView() -> some View {
        Group {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                Color.black
                    .edgesIgnoringSafeArea(.all)
            } else {
                Color.white
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

#Preview {
    ChannelTabScreen(.placeholder)
}
