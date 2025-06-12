import SwiftUI

struct SettingsItemView: View {
    let item: SettingsItem
    
    var body: some View {
        HStack {
            
            Text(item.title)
                .font(.system(size: 18))
                .foregroundColor(.blue)
            
            Spacer()
            
            if item.isArrow {
                Image(systemName: "chevron.right")
                    .foregroundColor(.blue)
            }
        }
        .padding() 
    }
}

#Preview {
    SettingsItemView(item: .chats)
}
