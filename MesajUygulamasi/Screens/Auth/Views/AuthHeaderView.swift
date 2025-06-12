import SwiftUI

struct AuthHeaderView: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(.turkline)
                .resizable()
                .frame(width: 70, height: 70)
            
            Text("TurkLine")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}
