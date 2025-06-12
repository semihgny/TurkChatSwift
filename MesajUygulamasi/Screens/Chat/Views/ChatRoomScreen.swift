import SwiftUI
// Removed Combine import as keyboard notifications are no longer used

struct ChatRoomScreen: View {
    let kanal: ChannelItem
    @StateObject private var viewModel: ChatRoomViewModel
    // Removed @State private var keyboardHeight

    // // Kanal öğesi ile başlatıcı
    init(kanal: ChannelItem) {
        self.kanal = kanal
        _viewModel = StateObject(wrappedValue: ChatRoomViewModel(kanal))
    }

    // // Ana görünüm yapısı - Referans koda göre güncellendi
    var body: some View {
        MessageListView(viewModel)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                leadingNavItems()
                trailingNavItems()
            }
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(edges: .bottom) // Keep ignoring bottom safe area for the list view
            .safeAreaInset(edge: .bottom) { // Use safeAreaInset for the input area
                bottomSafeAreaView()
                    .background(Color.turklineWhite) // Match reference background
            }
            .background(Color(.systemGroupedBackground)) // Apply background to the whole view
            // Removed .onAppear and .onDisappear for keyboard notifications
    }

    // // Alt güvenli alan ve metin giriş alanını içeren görünüm
    private func bottomSafeAreaView() -> some View {
        VStack(spacing: 0) {
            Divider()

            TextInputArea(
                textMessage: $viewModel.textMessage,
                isRecording: $viewModel.isRecordingVoiceMessage,
                elsapsedTime: $viewModel.elapsedVoiceMessageTime,
                disableSendButton: viewModel.disableSendButton
            ) { action in
                viewModel.handleTextInputArea(action)
            }
            .padding(.horizontal) // Keep horizontal padding
            // Removed background modifier here, applied in safeAreaInset
            // Removed extra conditional padding
        }
    }

    // Removed keyboard notification handling functions (setupKeyboardNotifications, removeKeyboardNotifications)
}

// ... rest of the ChatRoomScreen extension and Preview ...

extension ChatRoomScreen {
    // // Kanal başlığını hesaplama ve kısaltma
    private var channelTitle: String {
        let maxChar = 20
        let trailingChars = kanal.title.count > maxChar ? "..." : ""
        let title = String(kanal.title.prefix(maxChar) + trailingChars)
        return title
    }

    // // Navigasyon çubuğunun sol tarafındaki öğeleri oluşturma
    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            HStack {
                // Kanalın Profil Resmi
                CircularProfileImageView(kanal, size: .mini)

                // Kanal Başlığı
                Text(channelTitle)
                    .font(.headline)
                    .bold()
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
    }

    // // Navigasyon çubuğunun sağ tarafındaki öğeleri oluşturma
    @ToolbarContentBuilder
    private func trailingNavItems() -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            // Butonlar Burada Kaldırıldı (Referans dosyada video/phone butonları vardı, ama önceki isteklere göre kaldırılmıştı, kaldırılmış haliyle bırakıyorum)
        }
    }
}

#Preview {
    NavigationStack {
        ChatRoomScreen(kanal: .placeholder)
    }
}

