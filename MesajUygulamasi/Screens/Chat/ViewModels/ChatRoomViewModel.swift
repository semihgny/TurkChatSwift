import Foundation
import Combine
import SwiftUI

final class ChatRoomViewModel: ObservableObject {
    @Published var textMessage = ""
    @Published var messages = [MessageItem]()
    @Published var isRecordingVoiceMessage = false
    @Published var elapsedVoiceMessageTime: TimeInterval = 0
    @Published var scrollToBottomRequest: (scroll: Bool, isAnimated: Bool) = (false, false)
    @Published var isPaginating = false
    private var currentPage: String?
    private var firstMessage: MessageItem?
    
    private(set) var kanal: ChannelItem
    private var subscriptions = Set<AnyCancellable>()
    private var currentUser: UserItem?
    
    // // Gönderme düğmesinin etkin olup olmadığını belirler
    var disableSendButton: Bool {
        return textMessage.isEmptyOrWhitespace
    }
    
    // // Önizleme modunda olup olmadığını kontrol eder
    private var isPreviewMode: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    // // ViewModel başlatıcısı
    init(_ kanal: ChannelItem) {
        self.kanal = kanal
        listenToAuthState()
        
        if isPreviewMode {
            messages = MessageItem.stubMessages
        }
    }
    
    // // Nesne yok edildiğinde abonelikleri iptal eder
    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        currentUser = nil
    }
    
    // // Kimlik doğrulama durumunu dinler
    private func listenToAuthState() {
        AuthManager.shared.authState.receive(on: DispatchQueue.main).sink {[weak self] authState in
            guard let self = self else { return }
            switch authState {
            case .authenticated(let currentUser):
                self.currentUser = currentUser
                
                if self.kanal.allMembersFetched {
                    self.getHistoricalMessages()
                } else {
                    self.getAllChannelMembers()
                }
                
            default:
                break
            }
        }.store(in: &subscriptions)
    }
    
    // // Metin mesajı gönderir
    func sendMessage() {
        sendTextMessage(textMessage)
    }
    
    // // Özel metin mesajı gönderme işlevi
    private func sendTextMessage(_ text: String) {
        guard let currentUser else { return }
        MessageService.sendTextMessage(to: kanal, from: currentUser, textMessage) {[weak self] in
            self?.textMessage = ""
        }
    }
    
    // // Metin giriş alanını temizler
    private func clearTextInputArea() {
        textMessage = ""
        UIApplication.dismissKeyboard()
    }
    
    // // Sohbeti en alta kaydırır
    private func scrollToBottom(isAnimated: Bool) {
        scrollToBottomRequest.scroll = true
        scrollToBottomRequest.isAnimated = isAnimated
    }
    
    // // Daha fazla mesaj yüklenip yüklenemeyeceğini belirler
    var isPaginatable: Bool {
        return currentPage != firstMessage?.id
    }
    
    // // Geçmiş mesajları alır
    private func getHistoricalMessages() {
        isPaginating = currentPage != nil
        MessageService.getHistoricalMessages(for: kanal, lastCursor: currentPage, pageSize: 12) {[weak self] messageNode in
            if self?.firstMessage == nil {
                self?.getFirstMessage()
                self?.listenForNewMessages()
            }
            self?.messages.insert(contentsOf: messageNode.messages, at: 0)
            self?.currentPage = messageNode.currentCursor
            self?.scrollToBottom(isAnimated: false)
            self?.isPaginating = false
        }
    }
    
    // // Daha fazla mesaj yükler
    func paginateMoreMessages() {
        guard isPaginatable else { isPaginating = false; return }
        getHistoricalMessages()
    }
    
    // // Kanaldeki ilk mesajı alır
    private func getFirstMessage() {
        MessageService.getFirstMessage(in: kanal) {[weak self] firstMessage in
            self?.firstMessage = firstMessage
        }
    }
    
    // // Yeni mesajları dinler
    private func listenForNewMessages() {
        MessageService.listenForNewMessages(in: kanal) {[weak self] newMessage in
            self?.messages.append(newMessage)
            self?.scrollToBottom(isAnimated: false)
        }
    }
    
    // // Tüm kanal üyelerini alır
    private func getAllChannelMembers() {
        guard let currentUser = currentUser else { return }
        let membersAlreadyFetched = kanal.members.compactMap { $0.id }
        var memberUIDSToFetch = kanal.memberUids.filter{ !membersAlreadyFetched.contains($0) }
        memberUIDSToFetch = memberUIDSToFetch.filter { $0 != currentUser.uid }
        
        UserService.getUsers(with: memberUIDSToFetch) { [weak self] userNode in
            guard let self = self else { return }
            self.kanal.members.append(contentsOf: userNode.users)
            self.getHistoricalMessages()
            print("Members: \(kanal.members.map { $0.username })")
        }
    }
    
    // // Metin giriş alanı eylemlerini işler
    func handleTextInputArea(_ action: TextInputArea.UserAction) {
        switch action {
        case .sendMessage:
            sendMessage()
        }
    }
    
    // // Mesajın yeni bir güne ait olup olmadığını kontrol eder
    func isNewDay(for mesaj: MessageItem, at index: Int) -> Bool {
        let priorIndex = max(0, (index - 1))
        let priorMessage = messages[priorIndex]
        return !mesaj.timeStamp.isSameDay(as: priorMessage.timeStamp)
    }
    
    // // Gönderen adının gösterilip gösterilmeyeceğini belirler
    func showSenderName(for mesaj: MessageItem, at index: Int) -> Bool {
        guard kanal.isGroupChat else { return false }
        
        let isNewDay = isNewDay(for: mesaj, at: index)
        let priorIndex = max(0, (index - 1))
        let priorMessage = messages[priorIndex]
        
        if isNewDay {
            return !mesaj.isSentByMe
        } else {
            return !mesaj.isSentByMe && !mesaj.containsSameOwner(as: priorMessage)
        }
    }
    
    // // Mesaja tepki ekler
    func addReaction(_ reaction: Reaction, to mesaj: MessageItem) {
        guard let currentUser else { return }
        guard let index = messages.firstIndex(where: { $0.id == mesaj.id }) else { return }
        MessageService.addReaction(reaction, to: mesaj, in: kanal, from: currentUser) { [weak self] emojiCount in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                self?.messages[index].reactions[reaction.emoji] = emojiCount
                self?.messages[index].userReactions[currentUser.uid] = reaction.emoji
            }
        }
    }
}

