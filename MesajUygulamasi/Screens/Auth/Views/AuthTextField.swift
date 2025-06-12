import SwiftUI

struct AuthTextField: View {
    let type: InputType
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: type.imageName)
                .foregroundColor(.gray)
                .frame(width: 24)

            switch type {
            case .password:
                SecureField(type.placeholder, text: $text)
            default:
                TextField(type.placeholder, text: $text)
                    .keyboardType(type.keyboardType)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

extension AuthTextField {
    enum InputType {
        case email
        case password
        case custom(_ placeholder: String, _ iconName: String)
        
        var placeholder: String {
            switch self {
            case .email:
                return "E-posta"
            case .password:
                return "Şifre"
            case .custom(let placeholder, _):
                return placeholder
            }
        }
        
        var imageName: String {
            switch self {
            case .email:
                return "envelope"
            case .password:
                return "lock"
            case .custom(_, let iconName):
                return iconName
            }
        }
        
        var keyboardType: UIKeyboardType {
            switch self {
            case .email:
                return .emailAddress
            default:
                return .default
            }
        }
    }
}
