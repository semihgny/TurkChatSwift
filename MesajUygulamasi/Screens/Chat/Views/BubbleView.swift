
import SwiftUI

struct BubbleView: View {
    let mesaj: MessageItem
    let kanal: ChannelItem
    let isNewDay: Bool
    let showSenderName: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            if isNewDay {
                newDayTimeStampTextView()
                    .padding()
            }
            
            if showSenderName {
                senderNameTextView()
            }
            
            composeDynamicBubbleView()
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, mesaj.hasReactions ? 8 : 0)
    }
    
    @ViewBuilder
    private func composeDynamicBubbleView() -> some View {
        switch mesaj.type {
        case .text:
            BubbleTextView(item: mesaj)
        case .photo, .video:
            BubbleTextView(item: mesaj)
        case .audio:
            BubbleTextView(item: mesaj)
        case .admin(let adminType):
            switch adminType {
            case .channelCreation:
                
                newDayTimeStampTextView()
                ChannelCreationTextView()
                    .padding()
                
                if kanal.isGroupChat {
                    AdminMessageTextView(kanal: kanal)
                }
            default:
                Text("Admin mesaj")
            }
        }
    }
    
    private func newDayTimeStampTextView() -> some View {
        Text(mesaj.timeStamp.relativeDateString)
            .font(.caption)
            .bold()
            .padding(.vertical, 3)
            .padding(.horizontal)
            .background(Color.turklineGray)
            .clipShape(Capsule())
            .frame(maxWidth: .infinity)
    }
    
    private func senderNameTextView() -> some View {
        Text(mesaj.sender?.username ?? "Unknown")
            .lineLimit(1)
            .foregroundColor(.gray)
            .font(.footnote)
            .padding(.bottom, 2)
            .padding(.horizontal)
            .padding(.leading, 20)
    }
}

#Preview {
    BubbleView(mesaj: .sentPlaceholder, kanal: .placeholder, isNewDay: false, showSenderName: false)
}
