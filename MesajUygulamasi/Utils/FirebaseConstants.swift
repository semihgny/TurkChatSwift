
import Firebase
import FirebaseStorage

enum FirebaseConstants {
    static let StorageRef = Storage.storage().reference()
    private static let DatabaseRef = Database.database().reference()
    static let UserRef = DatabaseRef.child("users")
    static let ChannelsRef = DatabaseRef.child("channels")
    static let MessagesRef = DatabaseRef.child("kanal-messages")
    static let UserChannelsRef = DatabaseRef.child("kullanıcı-channels")
    static let UserDirectChannels = DatabaseRef.child("kullanıcı-direct-channels")
}
