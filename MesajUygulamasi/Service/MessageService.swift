
import Foundation
import FirebaseDatabaseInternal

struct MessageService {
    static func sendTextMessage(to kanal: ChannelItem, from currentUser: UserItem, _ textMessage: String, onComplete: () -> Void) {
        let timeStamp = Date().timeIntervalSince1970
        guard let messageId = FirebaseConstants.MessagesRef.child(kanal.id).childByAutoId().key else { return }
        
        let channelDict: [String: Any] = [
            .lastMessage: textMessage,
            .lastMessageTimestamp: timeStamp,
            .lastMessageType: MessageType.text.title
        ]
            
        let messageDict: [String: Any] = [
            .text: textMessage,
            .type: MessageType.text.title,
            .timeStamp: timeStamp,
            .ownerUid: currentUser.uid
        ]
        
        FirebaseConstants.ChannelsRef.child(kanal.id).updateChildValues(channelDict)
        FirebaseConstants.MessagesRef.child(kanal.id).child(messageId).setValue(messageDict)
        
        onComplete()
    }
    
    static func sendMediaMessage(to kanal: ChannelItem, params: MessageUploadParams, completion: @escaping() -> Void) {
        guard let messageId = FirebaseConstants.MessagesRef.childByAutoId().key else { return }
        let timeStamp = Date().timeIntervalSince1970
        
        let channelDict: [String: Any] = [
            .lastMessage: params.text,
            .lastMessageTimestamp: timeStamp,
            .lastMessageType: params.type.title
        ]
        
        var messageDict: [String: Any] = [
            .text: params.text,
            .type: params.type.title,
            .timeStamp: timeStamp,
            .ownerUid: params.ownerUID
        ]
        
        messageDict[.thumbnailUrl] = params.thumbnailURL ?? nil
         messageDict[.videoURL] = params.videoURL ?? nil
        
        messageDict[.audioURL] = params.audioURL ?? nil
        messageDict[.audioDuration] = params.audioDuration ?? nil
        
        FirebaseConstants.ChannelsRef.child(kanal.id).updateChildValues(channelDict)
        FirebaseConstants.MessagesRef.child(kanal.id).child(messageId).setValue(messageDict) { error, _ in
            if error == nil {
                FirebaseConstants.ChannelsRef.child(kanal.id).updateChildValues(channelDict)
            }
        }
        completion()
    }
    
    static func getMessages(for kanal: ChannelItem, completion: @escaping([MessageItem]) -> Void) {
        FirebaseConstants.MessagesRef.child(kanal.id).observe(.value) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }
            var messages: [MessageItem] = []
            dict.forEach { key, value in
                let messageDict = value as? [String: Any] ?? [:]
                var mesaj = MessageItem(id: key, isGroupChat: kanal.isGroupChat, dict: messageDict)
                let messageSender = kanal.members.first(where: { $0.uid == mesaj.ownerUid })
                mesaj.sender = messageSender
                messages.append(mesaj)
                if messages.count == snapshot.childrenCount {
                    messages.sort { $0.timeStamp < $1.timeStamp }
                    completion(messages)
                }
            }
        } withCancel: { error in
            print("Failed to fetch messages: \(error.localizedDescription)")
        }
    }
    
    static func getHistoricalMessages(
        for kanal: ChannelItem,
        lastCursor: String?,
        pageSize: UInt,
        completion: @escaping (MessageNode) -> Void) {
            
        let query: DatabaseQuery
            
        if lastCursor == nil {
            query = FirebaseConstants.MessagesRef.child(kanal.id).queryLimited(toLast: pageSize)
        } else {
            query = FirebaseConstants.MessagesRef.child(kanal.id).queryOrderedByKey().queryEnding(atValue: lastCursor).queryLimited(toLast: pageSize)
        }
        
        query.observeSingleEvent(of: .value) { mainSnapshot in
            
            guard let first = mainSnapshot.children.allObjects.first as? DataSnapshot, let allObjects = mainSnapshot.children.allObjects as? [DataSnapshot] else { return }
                
            var messages: [MessageItem] = allObjects.compactMap { messageSnapshot in
                let messageDict = messageSnapshot.value as? [String: Any] ?? [:]
                var mesaj = MessageItem(id: messageSnapshot.key, isGroupChat: kanal.isGroupChat, dict: messageDict)
                let messageSender = kanal.members.first(where: { $0.uid == mesaj.ownerUid })
                mesaj.sender = messageSender
                return mesaj
            }
            
            messages.sort { $0.timeStamp < $1.timeStamp }
            
            if messages.count == mainSnapshot.childrenCount {
                if lastCursor == nil {
                    messages.removeLast()
                }
                let filterMessages = lastCursor == nil ? messages : messages.filter { $0.id != lastCursor }
                let messageNode = MessageNode(messages: filterMessages, currentCursor: first.key)
                
                completion(messageNode)
            }
        } withCancel: { error in
            print("Failed to fetch historical messages: \(error.localizedDescription)")
            completion(.emptyNode)
        }
    }
    
    static func getFirstMessage(in kanal: ChannelItem, completion: @escaping (MessageItem) -> Void) {
        FirebaseConstants.MessagesRef.child(kanal.id)
            .queryLimited(toFirst: 1)
            .observeSingleEvent(of: .value) { snapshot  in
                guard let dict = snapshot.value as? [String: Any] else { return }
                dict.forEach { key, value in
                    guard let messageDict = value as? [String: Any] else { return }
                    var firstMessage = MessageItem(id: key, isGroupChat: kanal.isGroupChat, dict: messageDict)
                    let messageSender = kanal.members.first(where: { $0.uid == firstMessage.ownerUid })
                    firstMessage.sender = messageSender
                    completion(firstMessage)
                }
                    
            } withCancel: { error in
                print("Failed to fetch first mesaj: \(error.localizedDescription)")
            }
    }
    
    static func listenForNewMessages(in kanal: ChannelItem, completion: @escaping (MessageItem) -> Void) {
        FirebaseConstants.MessagesRef.child(kanal.id)
            .queryLimited(toLast: 1)
            .observe(.childAdded) { snapshot in
                guard let dict = snapshot.value as? [String: Any] else { return }
                var newMessage = MessageItem(id: snapshot.key, isGroupChat: kanal.isGroupChat, dict: dict)
                let messageSender = kanal.members.first(where: { $0.uid == newMessage.ownerUid })
                newMessage.sender = messageSender
                completion(newMessage)
            }
    }
    
    static func increaseCountViaTransaction(at ref: DatabaseReference, completion: ((Int) -> Void)? = nil) {
        ref.runTransactionBlock { currentData in
            if var count = currentData.value as? Int {
                count += 1
                currentData.value = count
            } else {
                currentData.value = 1
            }
            completion?(currentData.value as? Int ?? 0)
            return TransactionResult.success(withValue: currentData)
        }
    }
    
    static func addReaction(_ reaction: Reaction, to mesaj: MessageItem, in kanal: ChannelItem, from currentUser: UserItem, completion: @escaping (_ emojiCount: Int) -> Void) {
        let reactionsRef = FirebaseConstants.MessagesRef.child(kanal.id).child(mesaj.id).child(.reactions).child(reaction.emoji)
        
        increaseCountViaTransaction(at: reactionsRef) { emojiCount in
            FirebaseConstants.MessagesRef.child(kanal.id).child(mesaj.id).child(.userReactions).child(currentUser.uid).setValue(reaction.emoji)
            
            completion(emojiCount)
        }
            
        
    }
}

struct MessageNode {
    var messages: [MessageItem]
    var currentCursor: String?
    static let emptyNode = MessageNode(messages: [], currentCursor: nil)
}


struct MessageUploadParams {
    let kanal: ChannelItem
    let text: String
    let type: MessageType
    var thumbnailURL: String?
    var videoURL: String?
    var sender: UserItem
    var audioURL: String?
    var audioDuration: TimeInterval?
    
    var ownerUID: String {
        return sender.uid
    }
    

}
