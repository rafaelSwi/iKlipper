import Foundation
import SwiftUI

struct FileListView: View {
    
    @Environment (\.presentationMode) var presentationMode
    
    @Binding var internalFiles: [Network.AvailableFiles.Result]
    @Binding var usbFiles: [Network.AvailableFiles.Result]
    
    var body: some View {
        
        Spacer()
        
        ScrollView {
            
            Group {
                Text (internalFiles.isEmpty ? "" : "Internal Files")
                    .font(.title2)
                    .bold()
                ForEach(internalFiles) { file in
                    ItemBox(file: file)
                }
            }
            
            Group {
                Text (usbFiles.isEmpty ? "" : "USB Files")
                    .font(.title2)
                    .bold()
                    .padding(.top)
                ForEach(usbFiles) { file in
                    ItemBox(file: file)
                }
            }
            
        }
        
        Spacer()
        
        DefaultView.ReturnButton()
            .onTapGesture {
                presentationMode.wrappedValue.dismiss()
            }
    }
}
