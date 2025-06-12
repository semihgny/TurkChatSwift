
import SwiftUI

struct MessageReactionView: View {
    let mesaj: MessageItem
    private var emojis: [String] {
        return mesaj.reactions.map { $0.key }
    }
    private var emojisCount: Int {
        return mesaj.reactions.map { $0.value }.reduce(0, +)
    }
    
    var body: some View {
        if mesaj.hasReactions {
            HStack(spacing: 2) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .fontWeight(.semibold)
                }
                
                if emojisCount > 1 {
                    Text(emojisCount.description)
                        .fontWeight(.semibold)
                }
            }
            .font(.footnote)
            .padding(4)
            .padding(.horizontal, 2)
            .background(Capsule().fill(.thinMaterial))
            .overlay(Capsule().stroke(mesaj.backgroundColor, lineWidth: 2))
            .shadow(color: mesaj.backgroundColor.opacity(0.3), radius: 5, x: 0, y: 5)
        }
    }
}

#Preview {
    MessageReactionView(mesaj: .receivedPlaceholder)
}
