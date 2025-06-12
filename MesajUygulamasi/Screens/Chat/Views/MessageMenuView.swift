
import SwiftUI

struct MessageMenuView: View {
    let mesaj: MessageItem
    @State private var animateBackgroundView = false
    
    var body: some View {
        // Mesaj etkileşim menüsü
        EmptyView()
    }
}

#Preview {
    MessageMenuView(mesaj: .sentPlaceholder)
}
