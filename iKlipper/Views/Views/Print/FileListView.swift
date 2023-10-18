import Foundation
import SwiftUI

struct FileListView: View {
    
    @Environment (\.presentationMode) var presentationMode
    
    @Binding var internalFiles: [Network.AvailableFiles.Result]
    @Binding var usbFiles: [Network.AvailableFiles.Result]
    @Binding var usbSavedFiles: [Network.AvailableFiles.Result]
    
    var body: some View {
        
        Spacer()
        
        ScrollView {
            
            Group {
                Text (internalFiles.isEmpty ? "" : String(localized: "print.filelist.internal_files"))
                    .font(.title2)
                    .bold()
                ForEach(internalFiles) { file in
                    ItemBox(file: file)
                }
            }
            
            Group {
                Text (usbFiles.isEmpty ? "" : String(localized: "print.filelist.usb_files"))
                    .font(.title2)
                    .bold()
                    .padding(.top)
                ForEach(usbFiles) { file in
                    ItemBox(file: file)
                }
            }
            
            Group {
                Text (usbFiles.isEmpty ? "" : String(localized: "print.filelist.saved_from_usb"))
                    .font(.title2)
                    .bold()
                    .padding(.top)
                ForEach(usbSavedFiles) { file in
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
