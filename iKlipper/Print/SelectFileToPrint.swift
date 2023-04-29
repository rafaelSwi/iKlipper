import SwiftUI
/*
struct SelectFileToPrint: View {
    
    @Environment (\.presentationMode) var presentationMode
    
    @State private var listOfFiles: [NetworkStruct.AvailableFiles.Result] = []
    
    @State private var fullFileList: [NetworkStruct.AvailableFiles.Result] = []
    
    @State private var wantToFetchFiles: Bool = false
    
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
                        wantToFetchFiles.toggle()
                        for item in fullFileList {
                            if !item.path.hasPrefix("USB") {
                                listOfFiles.append(item)
                            }
                        }
                    }
                
                Image(systemName: "cable.connector")
                    .frame(width: 80, height: 80)
                    .onTapGesture {
                        cleanBothLists()
                            wantToFetchFiles.toggle()
                            for item in fullFileList {
                                if item.path.hasPrefix("USB") {
                                    listOfFiles.append(item)
                                }
                        }
                    }
                
                
            }
            .foregroundColor(.white)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(32)
            .padding(.all)
            
            .fullScreenCover(isPresented: $wantToFetchFiles) {
                FileFetchLoadingScreen(listOfFiles: $fullFileList)
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
    
    @Binding var listOfFiles: [NetworkStruct.AvailableFiles.Result]
    
    @State var ready: Bool = false
    
    var body: some View {

        if !ready {
            DefaultView.LoadingSpin()
                .animation(.spring())
                .onAppear(perform: {
                    Task {
                        listOfFiles = try await GET.Server.filesList()
                        if !listOfFiles.isEmpty {
                            ready.toggle()
                        }
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
    
    @Binding var listOfFiles: [NetworkStruct.AvailableFiles.Result]
    
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
    
    @State var file: NetworkStruct.AvailableFiles.Result
    
    @State var wantToPrint: Bool = false
    
    func goodLookingName(_ name: String) -> String {
        var result = name
        if let index = result.range(of: ".", options: .backwards)?.lowerBound {
            result = String(result[..<index])
        }
        result = result.replacingOccurrences(of: "_", with: " ")
        result = result.replacingOccurrences(of: "USB/", with: "")
        return result.capitalized
    }

    
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
    
    @State var file: NetworkStruct.AvailableFiles.Result
    
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
                
                Text ("\(self.file.path)")
                
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
                    try await POST.Print.printfilename(self.file.path)
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
*/
