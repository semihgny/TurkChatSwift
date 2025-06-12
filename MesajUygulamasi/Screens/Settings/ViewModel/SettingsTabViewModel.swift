
import Foundation
import SwiftUI
import PhotosUI
import Combine
import FirebaseAuth
import AlertKit

@MainActor
final class SettingsTabViewModel: ObservableObject {
    @Published var selectedPhotoItem: PhotosPickerItem?
    @Published var showSuccessHUD = false
    @Published var showUserInfoEditor = false
    @Published var name = ""
    @Published var bio = ""
    
    private var currentUser: UserItem
    
    private(set) var progressHUDView = AlertAppleMusic17View(title: "Uploading Profile Photo", subtitle: nil, icon: .spinnerSmall)
    private(set) var successHUDView = AlertAppleMusic17View(title: "Profile Info Updated!", subtitle: nil, icon: .done)
    
    private var subscription: AnyCancellable?
    
    var disableSaveButton: Bool {
        return true
    }
    
    init(_ currentUser: UserItem) {
        self.currentUser = currentUser
        self.name = currentUser.username
        self.bio = currentUser.bio ?? ""
        onPhotoPickerSelection()
    }
    
    private func onPhotoPickerSelection() {
        subscription = $selectedPhotoItem
            .receive(on: DispatchQueue.main)
            .sink { [weak self] photoItem in
                guard let photoItem = photoItem else { return }
                self?.parsePhotoPickerItem(photoItem)
            }
    }
    
    private func parsePhotoPickerItem(_ photoItem: PhotosPickerItem) {
        Task {
            
                                                
        }
    }
    
   
    private func onUploadSuccess(_ imageUrl: URL) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        FirebaseConstants.UserRef.child(currentUid).child(.profileImageURL).setValue(imageUrl.absoluteString)
        progressHUDView.dismiss()
        currentUser.profileImageURL = imageUrl.absoluteString
        AuthManager.shared.authState.send(.authenticated(currentUser))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showSuccessHUD = true
        }
    }
    
    func updateUsernameBio() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        var dict: [String: Any] = [.bio: bio]
        currentUser.bio = bio
        
        if !name.isEmptyOrWhitespace {
            dict[.username] = name
            currentUser.username = name
        }
        
        FirebaseConstants.UserRef.child(currentUid).updateChildValues(dict)
        showSuccessHUD = true
        AuthManager.shared.authState.send(.authenticated(currentUser))
    }
}
