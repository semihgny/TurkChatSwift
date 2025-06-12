import SwiftUI

struct NewGroupSetUpScreen: View {
    @State private var channelName = ""
    @ObservedObject var viewModel = ChatPartnerPickerViewModel()
    
    var onCreate: (_ newChannel: ChannelItem) -> Void
    
    var body: some View {
        List {
            Section {
                channelSetUpHeaderView()
            }
            
            Section {
                SelectedChatPartnerView(users: viewModel.selectedChatPartners) { kullanıcı in
                    viewModel.handleItemSelection(kullanıcı)
                }
            } header: {
                let count = viewModel.selectedChatPartners.count
                let maxCount = ChannelContants.maxGroupChatMembers
                
                Text("Katılımcılar: \(count) / \(maxCount)")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .bold()
            }
            .listRowBackground(Color.clear)
        }
        .navigationTitle("Yeni Grup")
        .toolbar {
            trailNavItem()
        }
    }
    
    private func channelSetUpHeaderView() -> some View {
        TextField("Grup adı (isteğe bağlı)", text: $channelName)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.blue.opacity(0.6), lineWidth: 1)
            )
            .font(.body)
    }
    
    @ToolbarContentBuilder
    private func trailNavItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Oluştur") {
                if viewModel.isDirectChannel {
                    guard let chatPartner = viewModel.selectedChatPartners.first else { return }
                    viewModel.createDirectChannel(chatPartner, completion: onCreate)
                } else {
                    viewModel.createGroupChannel(channelName, completion: onCreate)
                }
            }
            .foregroundColor(.blue)
            .bold()
            .disabled(viewModel.disableNextButton)
        }
    }
}

#Preview {
    NavigationStack {
        NewGroupSetUpScreen(viewModel: ChatPartnerPickerViewModel()) { _ in }
    }
}
