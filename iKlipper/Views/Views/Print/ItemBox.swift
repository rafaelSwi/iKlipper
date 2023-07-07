import Foundation
import SwiftUI

struct ItemBox: View {
    
    @State var file: Network.AvailableFiles.Result
    
    @State var wantToPrint: Bool = false
    
    var body: some View {
        
        HStack {
            
            if TextFormat.doesHasPrefix(self.file.path, "SX1") {
                Text ("X1")
                    .bold()
                    .foregroundColor(.gray)
            } else if TextFormat.doesHasPrefix(self.file.path, "SX2") {
                Text ("X2")
                    .bold()
                    .foregroundColor(.gray)
            } else {
                Image(systemName: "cube.transparent")
                    .foregroundColor(.gray)
            }
            
            Text (TextFormat.beauty(self.file.path, .removeParenthesesContent).prefix(25))
            Text (TextFormat.beauty(self.file.path, .extractParenthesesContent))
                .font(.system(size: 13))
                .foregroundColor(.gray)
                .offset(y: 2)
            
            Spacer()
            
            DefaultView.Custom.IconButton(systemName: "play.fill", w: 50, h: 50, cr: 12)
                .onTapGesture {
                    wantToPrint.toggle()
                }
            
                .fullScreenCover(isPresented: $wantToPrint) {
                    AreYouSurePrint(file: file)
                }
            
        }
        .frame(height: 50)
        .padding(.horizontal)
        
    }
}

