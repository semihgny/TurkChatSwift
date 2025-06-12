
import SwiftUI

struct ChannelCreationTextView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private var backgroundColor: Color {
        return colorScheme == .dark ? .black : Color.blue.opacity(0.8)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            (
                Text(Image(systemName: "lock.fill"))
                    +
                Text(" Bu sohbette bulunan kullanıcılar dışında hiç kimse, TurkLine bile, bu sohbeti okuyamaz.")
                                )
        }
        .font(.footnote)
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(backgroundColor.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding(.horizontal, 30)
    }
}

#Preview {
    ChannelCreationTextView()
}
