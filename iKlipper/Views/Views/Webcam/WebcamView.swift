import SwiftUI

struct WebcamView: View {
    
    @Environment (\.presentationMode) var presentationMode
    
    @EnvironmentObject var settings: MainSettings
    @EnvironmentObject var printerInfo: PrinterInfo
    
    @ObservedObject var webcam = ImageStream()
    
    var activeName: String {
        for printer in printerInfo.printers {
            if printerInfo.main.name == printer.name {
                return printer.name
            }
        }
        return "None"
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
                        webcam.play (
                            url: URL(string: printerInfo.main.webcam)!,
                            timeInterval: settings.camPerformance.time
                        )
                    }
                
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
