import SwiftUI

struct TextInputArea: View {
    @Binding var textMessage: String
    @Binding var isRecording: Bool
    @Binding var elsapsedTime: TimeInterval
    var disableSendButton: Bool
    
    let actionHandler: (_ action: UserAction) -> Void
    
    // // Metin giriş alanının ana görünümü
    var body: some View {
        HStack(alignment: .bottom, spacing: 5) {
            messageTextField()

            sendMessageButton()
                .disabled(disableSendButton)
                .grayscale(disableSendButton ? 0.8 : 0)
        }
        .padding(.bottom)
        .padding(.horizontal)
        .padding(.top, 10)
        .background(.turklineWhite)
    }
    
    // // Mesaj metin alanını oluşturan görünüm
    private func messageTextField() -> some View {
        TextField("", text: $textMessage, axis: .vertical)
            .padding(5)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(.systemGray5))
            )
            .overlay(textViewBorder())
    }
    
    // // Metin alanı kenarlığını oluşturan görünüm
    private func textViewBorder() -> some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .stroke(Color(.systemGray5), lineWidth: 1)
    }
    
    // // Mesaj gönderme düğmesini oluşturan görünüm
    private func sendMessageButton() -> some View {
        Button {
            actionHandler(.sendMessage)
        } label: {
            Image(systemName: "arrow.up")
                .fontWeight(.heavy)
                .foregroundStyle(.white)
                .padding(6)
                .background(.blue)
                .clipShape(Circle())
        }
    }
}

extension TextInputArea {
    // // Kullanıcı eylemlerini tanımlayan enum
    enum UserAction {
        case sendMessage
    }
}

#Preview {
    TextInputArea(textMessage: .constant(""), isRecording: .constant(false), elsapsedTime: .constant(0), disableSendButton: false) { action in
    }
}

