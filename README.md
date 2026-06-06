# TurkChatSwift

A real-time iOS messaging application built with Swift, SwiftUI, and Firebase. 

## Features

- **User Authentication**: Secure sign-up and login functionality.
- **Real-Time Messaging**: Send and receive messages instantly using Firebase.
- **Channels & Chats**: Create and join chat channels or communicate directly.
- **Settings**: Customizable user profile and app settings.
- **Modern UI**: Fully built with SwiftUI for a responsive and native iOS experience.

## Technologies Used

- **SwiftUI & Combine**: For building the declarative user interface and handling reactive data streams.
- **Firebase**: 
  - `FirebaseCore` for app configuration.
  - `FirebaseAuth` for user authentication.
  - `FirebaseDatabase` (Realtime Database) for real-time message syncing.
  - `FirebaseStorage` for handling media uploads (e.g., profile pictures or chat images).
- **Kingfisher**: For asynchronous image downloading and caching.
- **AlertKit**: For displaying custom, elegant alerts to the user.
- **MVVM Architecture**: Clean separation of concerns between Views, ViewModels, and Services.

## Requirements

- iOS 15.0+ (or recommended deployment target)
- Xcode 14.0+
- Swift 5.0+

## Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/semihgny/TurkChatSwift.git
   cd TurkChatSwift
   ```

2. **Open the project in Xcode:**
   Open the `MesajUygulamasi.xcodeproj` file in Xcode.

3. **Configure Firebase:**
   - Create a new project in the [Firebase Console](https://console.firebase.google.com/).
   - Add an iOS app to your Firebase project and download the `GoogleService-Info.plist` file.
   - Drag and drop the `GoogleService-Info.plist` file into the root of the `MesajUygulamasi` folder in Xcode.
   - Ensure the file is added to your app's target.

4. **Build and Run:**
   Select your preferred iOS Simulator or connected device in Xcode and press `Cmd + R` to build and run the application.

## Contributing

Contributions are welcome! If you'd like to improve the project, please fork the repository and submit a pull request.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.
