import SwiftUI

struct ChannelItemView: View {
    let kanal: ChannelItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            // Profil resmini yuvarlak şekilde gösteriyoruz
            CircularProfileImageView(kanal, size: .medium)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.blue, lineWidth: 2) // Çerçeve eklendi
                )
            
            VStack(alignment: .leading, spacing: 3) {
                titleTextView()
                lastMessagePreviewTextView()
            }
        }
        .padding(.vertical, 8)
        .background(BackgroundColorView()) // Arka plan rengi otomatik beyaz/siyah olacak
        .cornerRadius(12)
        .shadow(radius: 5) // Hafif gölge
    }
    
    private func titleTextView() -> some View {
        HStack {
            Text(kanal.title)
                .lineLimit(1)
                .font(.system(size: 18, weight: .bold)) // Başlık fontu
                .foregroundColor(.primary) // Metin rengi
            Spacer()
            Text(kanal.lastMessageTimestamp.dayOrTimeRepresentation)
                .foregroundColor(.gray)
                .font(.system(size: 15))
        }
    }
    
    private func lastMessagePreviewTextView() -> some View {
        HStack(spacing: 4) {
            if kanal.lastMessageType != .text {
                Image(systemName: kanal.lastMessageType.iconName)
                    .foregroundColor(.gray)
                    .imageScale(.small)
            }
            
            Text(kanal.previewMessage)
                .font(.system(size: 16))
                .lineLimit(2)
                .foregroundColor(.gray) // Preview metni için gri renk
        }
    }
    
    private func BackgroundColorView() -> some View {
        Group {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                Color.black.opacity(0.1) // Karanlık mod için daha koyu arka plan
                    .edgesIgnoringSafeArea(.all)
            } else {
                Color.white.opacity(0.8) // Aydınlık mod için daha açık arka plan
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

#Preview {
    ChannelItemView(kanal: .placeholder)
}
