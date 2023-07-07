import Foundation
import SwiftUI

/// Stores Views considered "default" for use throughout the app, such as buttons.
final class DefaultView {
    
    final class Custom {
        
        struct IconButton: View {
            @State var systemName: String
            @State var w: Int
            @State var h: Int
            @State var cr: Int
            var body: some View {
                Image(systemName: systemName)
                    .foregroundColor(.white)
                    .frame(width: CGFloat(self.w), height: CGFloat(self.h))
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(CGFloat(self.cr))
            }
        }
        
        struct IconTextButton: View {
            @State var text: String
            @State var systemName: String
            @State var w: Int
            @State var h: Int
            @State var cr: Int
            var body: some View {
                HStack {
                    Image(systemName: systemName)
                    Text (self.text)
                }
                .foregroundColor(.white)
                .frame(width: CGFloat(self.w), height: CGFloat(self.h))
                .background(Color.gray.opacity(0.2))
                .cornerRadius(CGFloat(self.cr))
            }
        }
    }
    
    struct ReturnButton: View {
        var body: some View {
            Image(systemName: "arrow.down")
                .foregroundColor(.white)
                .frame(width: 350, height: 40)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(28)
                .padding(.all)
        }
    }
}
