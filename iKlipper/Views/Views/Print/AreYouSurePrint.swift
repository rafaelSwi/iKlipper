import Foundation
import SwiftUI

struct AreYouSurePrint: View {
    
    @Environment (\.presentationMode) var presentationMode
    
    @EnvironmentObject var printerInfo: PrinterInfo
    
    @State var file: Network.AvailableFiles.Result
    
    @State var thumbnail: UIImage = UIImage(systemName: "cube")!
    
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
                
                if TextFormat.doesHasPrefix(self.file.path, "SX1") {
                    ZStack {
                        Image(systemName: "diamond")
                            .resizable()
                            .opacity(0.3)
                            .frame(width: 200, height: 200)
                        Text("X1")
                            .font(.system(size: 145).bold())
                            .padding(.bottom)
                    }
                } else if TextFormat.doesHasPrefix(self.file.path, "SX2") {
                    ZStack {
                        Image(systemName: "diamond")
                            .resizable()
                            .opacity(0.3)
                            .frame(width: 200, height: 200)
                        Text("X2")
                            .font(.system(size: 145).bold())
                            .padding(.bottom)
                    }
                } else {
                    ZStack {
                        Image(systemName: "cube.fill")
                            .resizable()
                            .opacity(0.2)
                            .frame(width: 200, height: 200)
                        Text("FILE")
                            .font(.system(size: 105).bold())
                            .padding(.bottom)
                    }
                }
                
                Text ("\(TextFormat.beauty(self.file.path, .removeParenthesesContent))")
                Text ("\(self.file.path)")
                    .font(.subheadline)
                    .onAppear {
                        Task {
                            thumbnail = try await GET.Server.thumbnail (
                                pr: printerInfo.main,
                                filename: self.file.path,
                                backup: "cube"
                            )
                        }
                    }
                Image(uiImage: thumbnail)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding(.all)
                
            }
            .font(.system(size: CGFloat(30)))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            
            Spacer()
            
            DefaultView.Custom.IconButton(systemName: "printer", w: 350, h: 70, cr: 28)
                .padding(.top)
                .onTapGesture {
                    Task {
                        try await POST.Print.printfilename(self.file.path, pr: printerInfo.main)
                    }
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    presentationMode.wrappedValue.dismiss()
                }
            
            DefaultView.ReturnButton()
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
        }
    }
}
