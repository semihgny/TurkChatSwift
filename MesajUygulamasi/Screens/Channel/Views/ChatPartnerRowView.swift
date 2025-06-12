
import SwiftUI

struct ChatPartnerRowView<Content: View>: View {
    private let kullanıcı: UserItem
    private let trailingItems: Content
    
    init(kullanıcı: UserItem, @ViewBuilder trailingItems: () -> Content = { EmptyView() }) {
        self.kullanıcı = kullanıcı
        self.trailingItems = trailingItems()
    }
    
    var body: some View {
        HStack {
            CircularProfileImageView(kullanıcı.profileImageURL, size: .xSmall)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading) {
                Text(kullanıcı.username)
                    .bold()
                    .foregroundStyle(.turklineBlack)
                
                Text(kullanıcı.bioUnwrapped)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            trailingItems
        }
    }
}

#Preview {
    ChatPartnerRowView(kullanıcı: .placeholder)
}
