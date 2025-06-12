import SwiftUI

struct MainTabView: View {
    
    private let currentUser: UserItem
    
    init(_ currentUser: UserItem) {
        self.currentUser = currentUser
        //makeTabBarOpaque()
        let thumbImage = UIImage(systemName: "circle.fill")
        UISlider.appearance().setThumbImage(thumbImage, for: .normal)
    }
    var body: some View {
        TabView {
            ChannelTabScreen(currentUser)
                .tabItem {
                    Image(systemName: Tab.chats.icon)
                    Text(Tab.chats.title)
                }
            SettingsTabScreen(currentUser)
                .tabItem {
                    Image(systemName: Tab.settings.icon)
                    Text(Tab.settings.title)
                }
        }
    }
    
    private func makeTabBarOpaque() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

extension MainTabView {
    private func placeholderItemView(_ title: String) -> some View {
        ScrollView {
            VStack {
                ForEach(0..<120) { _ in
                    Text(title)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .background(Color.orange.opacity(0.5))
                }
            }
        }
    }
    private enum Tab: String {
        case chats = "sohbetler", settings = "ayarlar"
        
        fileprivate var title: String {
            switch self {
            case .chats:
                return "Sohbetler"
            case .settings:
                return "Ayarlar"
            }
        }
        
        fileprivate var icon: String {
            switch self {
            case .chats:
                return "message"
            case .settings:
                return "gear"
            }
        }
    }
}

#Preview {
    MainTabView(UserItem.placeholder)
}
