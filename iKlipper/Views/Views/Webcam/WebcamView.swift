import SwiftUI

struct WebcamView: View {
    
    @Environment (\.presentationMode) var presentationMode
    
    @EnvironmentObject var settings: MainSettings
    @EnvironmentObject var printerInfo: PrinterInfo
    
    @ObservedObject var webcam = ImageStream()
    
    @State var viewInFullScreen: Bool = false
    
    var activeName: String {
        for printer in printerInfo.printers {
            if printerInfo.main.name == printer.name {
                return printer.name
            }
        }
        return "None"
    }
    
    func play () {
        webcam.play (
            url: URL(string: printerInfo.main.webcam)!,
            timeInterval: settings.camPerformance.time
        )
    }
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Text ("\(activeName)")
                .font(.system(size: 50).bold())
            
            ZStack {
                
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: 350, height: 185)
                    .cornerRadius(15)
                
                webcam.stream
                    .resizable()
                    .frame(width: 330, height: 165)
                    .onAppear {
                        play()
                    }
                
            }
            
            DefaultView.Custom.IconTextButton (
                text: "Reload Connection",
                systemName: "arrow.clockwise",
                w: 235,
                h: 45,
                cr: 28
            )
            .padding(.all)
            .onTapGesture {
                webcam.stop()
                play()
            }
            
            DefaultView.Custom.IconTextButton (
                text: "View in Full Screen",
                systemName: "ipad.landscape.badge.play",
                w: 235,
                h: 45,
                cr: 28
            )
            .onTapGesture {
                webcam.stop()
                viewInFullScreen.toggle()
            }
            .fullScreenCover(isPresented: $viewInFullScreen) {
                FullScreenWebcam()
            }
            
            Spacer()
            
            DefaultView.ReturnButton()
                .onTapGesture {
                    webcam.stop()
                    presentationMode.wrappedValue.dismiss()
                }
            
        }
        
    }
}
