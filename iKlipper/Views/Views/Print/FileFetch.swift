import SwiftUI
import Foundation

struct FileFetch: View {
    
    @State var fullFileList: [Network.AvailableFiles.Result] = []
    @State var internalFiles: [Network.AvailableFiles.Result] = []
    @State var usbFiles: [Network.AvailableFiles.Result] = []
    
    @EnvironmentObject var printerInfo: PrinterInfo
    
    @State var ready: Bool = false
    
    var body: some View {
        
        if !ready {
            ProgressView()
                .onAppear(perform: {
                    Task {
                        fullFileList = try await GET.Server.filesList(pr: printerInfo.main)
                        for item in fullFileList {
                            if !TextFormat.doesHasPrefix(item.path, "USB") {
                                internalFiles.append(item)
                            } else {
                                usbFiles.append(item)
                            }
                        }
                        ready.toggle()
                    }
                })
        }
        
        if ready {
            
            FileListView(internalFiles: $internalFiles, usbFiles: $usbFiles)
                .refreshable {
                    ready.toggle()
                }
        }
    }
}
