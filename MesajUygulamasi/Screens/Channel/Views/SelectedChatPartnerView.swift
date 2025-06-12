
import SwiftUI

struct SelectedChatPartnerView: View {
    let users: [UserItem]
    let onTapHandler: (_ kullanıcı: UserItem) -> Void
    
    var body: some View {
        ScrollView(.horizontal , showsIndicators: false) {
            HStack {
                ForEach(users) { item in
                    chatPartnerView(item)
                }
            }
        }
    }
    
    private func chatPartnerView(_ kullanıcı: UserItem) -> some View {
        VStack {
            CircularProfileImageView(kullanıcı.profileImageURL, size: .medium)
                .overlay(alignment: .topTrailing) {
                    cancelButton(kullanıcı)
                }
            
            Text(kullanıcı.username)
                
        }
    }
    
    private func cancelButton(_ kullanıcı: UserItem) -> some View {
        Button {
            onTapHandler(kullanıcı)
        } label: {
            Image(systemName: "xmark")
                .imageScale(.small)
                .foregroundColor(.white)
                .fontWeight(.semibold)
                .padding(5)
                .background(Color(.systemGray2))
                .clipShape(Circle())
        }
    }
}

#Preview {
    SelectedChatPartnerView(users: UserItem.placeholders) { kullanıcı in
        
    }
}
