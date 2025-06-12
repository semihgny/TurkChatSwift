
import Foundation
import FirebaseAuth

enum ChannelTabRoutes: Hashable {
    case chatRoom( _ kanal: ChannelItem)
}

final class ChannelTabViewModel: ObservableObject {
    
    @Published var navRoutes = [ChannelTabRoutes]()
    @Published var navigateToChatRoom = false
    @Published var newChannel: ChannelItem?
    @Published var showChatPartnerPickerView = false
    @Published var channels = [ChannelItem]()
    typealias ChannelId = String
    @Published var channelDict: [ChannelId: ChannelItem] = [:]
    
    private let currentUser: UserItem
    
    init(_ currentUser: UserItem) {
        self.currentUser = currentUser
        fetchCurrentUserChannels()
    }
    
    func onNewChannelCreation(_ kanal: ChannelItem) {
        showChatPartnerPickerView = false
        newChannel = kanal
        navigateToChatRoom = true
    }
    
    private func fetchCurrentUserChannels() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        FirebaseConstants.UserChannelsRef.child(currentUid).observe(.value) {[weak self] snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }
            dict.forEach { key, value in
                let channelId = key
                self?.getChannel(with: channelId)
            }
        } withCancel: { error in
            print("Failed to fetch kullanıcı channels: \(error.localizedDescription)")
        }
    }
    
    private func getChannel(with channelId: String) {
        FirebaseConstants.ChannelsRef.child(channelId).observe(.value) { [weak self] snapshot in
            guard let dict = snapshot.value as? [String: Any], let self = self else { return }
            var kanal = ChannelItem(dict)
            self.getChannelMembers(kanal) { members in
                kanal.members = members
                kanal.members.append(self.currentUser)
                self.channelDict[channelId] = kanal
                self.reloadData()
                //self.channels.append(kanal)
            }
            
        } withCancel: { error in
            print("Failed to fetch kanal: \(error.localizedDescription)")
        }
    }
    
    private func getChannelMembers(_ kanal: ChannelItem, completion: @escaping (_ members: [UserItem]) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let channelMembersUids = Array(kanal.memberUids.filter { $0 != currentUid }.prefix(2))
        UserService.getUsers(with: channelMembersUids) { userNode in
            completion(userNode.users)
        }
    }
    
    private func reloadData() {
        self.channels = Array(channelDict.values)
        self.channels.sort { $0.lastMessageTimestamp > $1.lastMessageTimestamp }
    }
}
