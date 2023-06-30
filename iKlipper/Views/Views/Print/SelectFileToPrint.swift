import SwiftUI

struct SelectFileToPrint: View {
    
    @Environment (\.presentationMode) var presentationMode
    
    @EnvironmentObject var printerInfo: PrinterInfo
    
    @State private var listOfFiles: [Network.AvailableFiles.Result] = []
    
    @State private var fullFileList: [Network.AvailableFiles.Result] = []
    
    @State private var wantToFetchFiles: Bool = false
    
    @State fileprivate var prefix: Prefix = .internal
    
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
                FileFetchLoadingScreen(fullFileList: $fullFileList, listOfFiles: $listOfFiles, prefix: $prefix)
            }
            
        }
        
        Spacer()
        
        DefaultView.ReturnButton()
            .onTapGesture {
                presentationMode.wrappedValue.dismiss()
            }
        
        
    }
}

fileprivate struct FileFetchLoadingScreen: View {
    
    @Binding var fullFileList: [Network.AvailableFiles.Result]
    
    @Binding var listOfFiles: [Network.AvailableFiles.Result]
    
    @Binding fileprivate var prefix: Prefix
    
    @EnvironmentObject var printerInfo: PrinterInfo
    
    @State var ready: Bool = false
    
    var body: some View {
        
        if !ready {
            DefaultView.LoadingSpin()
                .onAppear(perform: {
                    Task {
                        fullFileList = try await GET.Server.filesList(pr: printerInfo.main)
                        for item in fullFileList {
                            if prefix == .internal && !item.path.hasPrefix("USB") {
                                listOfFiles.append(item)
                            }
                            if prefix == .usb && item.path.hasPrefix("USB") {
                                listOfFiles.append(item)
                            }
                        }
                        ready.toggle()
                    }
                })
        }
        
        if ready {
            
            FileListView(listOfFiles: $listOfFiles)
                .refreshable {
                    ready.toggle()
                }
            
        }
        
    }
}

fileprivate struct FileListView: View {
    
    @Environment (\.presentationMode) var presentationMode
    
    @Binding var listOfFiles: [Network.AvailableFiles.Result]
    
    var body: some View {
        
        Spacer()
        
        if !listOfFiles.isEmpty {
            
            ScrollView {
                ForEach(listOfFiles) { file in
                    
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

fileprivate struct ItemBox: View {
    
    @State var file: Network.AvailableFiles.Result
    
    @State var wantToPrint: Bool = false
    
    var body: some View {
        
        HStack {
            
            Image(systemName: "cube.transparent")
            
            Text (goodLookingName(self.file.path))
            
            Spacer()
            
            Button (action: {
                wantToPrint.toggle()
            }) {
                DefaultView.Custom.IconButton(systemName: "arrowtriangle.forward", w: 50, h: 50, cr: 12)
            }
            .fullScreenCover(isPresented: $wantToPrint) {
                AreYouSurePrint(file: file)
            }
            
        } .frame(height: 50)
        
    }
}

fileprivate struct AreYouSurePrint: View {
    
    @Environment (\.presentationMode) var presentationMode
    
    @EnvironmentObject var printerInfo: PrinterInfo
    
    @State var file: Network.AvailableFiles.Result
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            VStack {
                
                Image(systemName: "cube.transparent")
                    .font(.system(size: 135))
                    .padding(.bottom)
                
                Text ("\(goodLookingName(self.file.path))")
                
                Text ("Last Modification:\n\(dateFormatter.string(from: Date(timeIntervalSince1970: file.modified)))")
                    .padding(.all)
                
                Text ("Size: \(String(format: "%.1f", Double(self.file.size) / 1048576.0)) mb")
                
            }
            .font(.system(size: CGFloat(30)))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            
            Spacer()
            
            Button(action: {
                Task {
                    try await POST.Print.printfilename(self.file.path, pr: printerInfo.main)
                }
            }) {
                DefaultView.Custom.IconButton(systemName: "printer", w: 350, h: 70, cr: 28)
                    .padding(.top)
            }
            
            DefaultView.ReturnButton()
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            
        }
        
    }
}

fileprivate func goodLookingName(_ name: String) -> String {
    var result = name
    if let index = result.range(of: ".", options: .backwards)?.lowerBound {
        result = String(result[..<index])
    }
    result = result.replacingOccurrences(of: "_", with: " ")
    result = result.replacingOccurrences(of: "USB/", with: "")
    result = result.replacingOccurrences(of: "/", with: " > ")
    result = result.replacingOccurrences(of: "?", with: "")
    return result.capitalized
}

fileprivate enum Prefix {
    case `internal`
    case usb
}
