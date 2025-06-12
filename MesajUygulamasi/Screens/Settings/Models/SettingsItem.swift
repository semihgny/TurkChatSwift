
import SwiftUI

struct SettingsItem {
    let imageName: String
    let imageColor: Color = .primary
    var imageType: ImageType = .systemImage
    let backgroundColor: Color
    let title: String
    var isArrow: Bool = true
    
    enum ImageType {
        case systemImage, assetImage
    }
}
// MARK: Settings Data
extension SettingsItem {
    
    
    static let broadcastLists = SettingsItem(
        imageName: "megaphone",
        backgroundColor: .clear,
        title: "Yayın Listeleri"
    )
    
    static let starredMessages = SettingsItem(
        imageName: "star",
        backgroundColor: .clear,
        title: "Yıldızlı Mesajlar"
    )
    
    static let linkedDevices = SettingsItem(
        imageName: "laptopcomputer",
        backgroundColor: .clear,
        title: "Bağlı Cihazlar"
    )
    
    static let account = SettingsItem(
        imageName: "key",
        backgroundColor: .clear,
        title: "Hesap"
    )
    
    static let privacy = SettingsItem(
        imageName: "lock",
        backgroundColor: .clear,
        title: "Gizlilik"
    )
    
    static let chats = SettingsItem(
        imageName: "mesaj",
        backgroundColor: .clear,
        title: "Sohbetler"
    )
    
    static let notifications = SettingsItem(
        imageName: "bell.badge",
        backgroundColor: .clear,
        title: "Bildirimler"
    )
    
    static let storage = SettingsItem(
        imageName: "arrow.up.arrow.down",
        backgroundColor: .clear,
        title: "Depolama ve Veri"
    )
    
    static let help = SettingsItem(
        imageName: "info",
        backgroundColor: .clear,
        title: "Yardım"
    )
    
    static let tellFriend = SettingsItem(
        imageName: "heart",
        backgroundColor: .clear,
        title: "Bir Arkadaşına Öner"
    )
    
    static let logout = SettingsItem(
        imageName: "door.right.hand.open",
        backgroundColor: .clear,
        title: "Çıkış Yap"
    )
}

// MARK: Contact Info Data
extension SettingsItem {
    static let media = SettingsItem(
        imageName: "photo",
        backgroundColor: .blue,
        title: "Medya, Bağlantılar ve Belgeler"
    )
    
    static let mute = SettingsItem(
        imageName: "speaker.wave.2.fill",
        backgroundColor: .green,
        title: "Sessize Al"
    )
    
    static let wallpaper = SettingsItem(
        imageName: "circles.hexagongrid",
        backgroundColor: .mint,
        title: "Duvar Kağıdı ve Ses"
    )
    
    static let saveToCameraRoll = SettingsItem(
        imageName: "square.and.arrow.down",
        backgroundColor: .yellow,
        title: "Film Rulosuna Kaydet"
    )
    
    static let encryption = SettingsItem(
        imageName: "lock.fill",
        backgroundColor: .blue,
        title: "Şifreleme"
    )
    
    static let disappearingMessages = SettingsItem(
        imageName: "timer",
        backgroundColor: .blue,
        title: "Kendiliğinden Silinen Mesajlar"
    )
    
    static let lockChat = SettingsItem(
        imageName: "lock.doc.fill",
        backgroundColor: .blue,
        title: "Sohbeti Kilitle"
    )
    
    static let contactDetails = SettingsItem(
        imageName: "person.circle",
        backgroundColor: .gray,
        title: "Kişi Bilgileri"
    )
}
