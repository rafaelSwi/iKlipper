import SwiftUI

/*
struct SelectFileToPrint: View {
    
    @Environment (\.presentationMode) var presentationMode
    
    @EnvironmentObject var printerInfo: PrinterInfo
    
    @State private var listOfFiles: [Network.AvailableFiles.Result] = []
    
    @State private var fullFileList: [Network.AvailableFiles.Result] = []
    
    @State private var wantToFetchFiles: Bool = false
    
    @State var prefix: Prefix = .internal
    
    func cleanBothLists () {
        fullFileList.removeAll()
        listOfFiles.removeAll()
    }
    
    var body: some View {
        
        Spacer()
        
        if !listOfFiles.isEmpty {
            ScrollView {
                ForEach(listOfFiles) { file in
                    ItemBox(file: file)
                }
            }
        }
        
        if listOfFiles.isEmpty {
            
            Text ("Access files from Internal Storage or a USB connection?")
                .font(.system(size: CGFloat(35)))
                .fontWeight(.ultraLight)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            HStack {
                
                Image(systemName: "internaldrive")
                    .frame(width: 80, height: 80)
                    .onTapGesture {
                        cleanBothLists()
                        self.prefix = .internal
                        wantToFetchFiles.toggle()
                    }
                
                Image(systemName: "cable.connector")
                    .frame(width: 80, height: 80)
                    .onTapGesture {
                        cleanBothLists()
                        self.prefix = .usb
                        wantToFetchFiles.toggle()
                    }
                
                
            }
            .foregroundColor(.white)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(32)
            .padding(.all)
            
            .fullScreenCover(isPresented: $wantToFetchFiles) {
                FileFetch(fullFileList: fullFileList, listOfFiles: listOfFiles)
            }
            
        }
        
        Spacer()
        
        DefaultView.ReturnButton()
            .onTapGesture {
                presentationMode.wrappedValue.dismiss()
            }
    }
}
*/
