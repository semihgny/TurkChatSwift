
import SwiftUI
import Kingfisher

struct CircularProfileImageView: View {
    let profileImageUrl: String?
    let size: Size
    let fallbackImage: FallbackImage
    
    init(_ profileImageUrl: String? = nil, size: Size) {
        self.profileImageUrl = profileImageUrl
        self.size = size
        self.fallbackImage = .singleUserIcon
    }
    
    var body: some View {
        if let profileImageUrl {
            KFImage(URL(string: profileImageUrl))
                .placeholder { ProgressView() }
                .resizable()
                .scaledToFill()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
        } else {
            placeholderImageView()
        }
    }
    
    private func placeholderImageView() -> some View {
        Image(systemName: fallbackImage.rawValue)
            .resizable()
            .scaledToFill()
            .imageScale(.large)
            .foregroundColor(.placeholder)
            .frame(width: size.dimension, height: size.dimension)
            .background(.white)
            .clipShape(Circle())
    }
}

extension CircularProfileImageView {
    enum Size {
        case mini, xSmall, small, medium, large, xLarge
        case custom(CGFloat)
        
        var dimension: CGFloat {
            switch self {
            case .mini:
                return 30
            case .xSmall:
                return 40
            case .small:
                return 50
            case .medium:
                return 60
            case .large:
                return 80
            case .xLarge:
                return 120
            case .custom(let value):
                return value
            }
        }
    }
    
    enum FallbackImage: String {
        case singleUserIcon = "person.circle.fill"
        case multiUserIcon = "person.2.circle.fill"
        
        init(for membersCount: Int) {
            switch membersCount {
            case 2:
                self = .singleUserIcon
            default:
                self = .multiUserIcon
            }
        }
            
    }
}

extension CircularProfileImageView {
    init(_ kanal: ChannelItem, size: Size) {
        self.profileImageUrl = kanal.coverImageUrl
        self.size = size
        self.fallbackImage = FallbackImage(for: kanal.membersCount)
    }
}

#Preview {
    CircularProfileImageView(size: .large)
}
