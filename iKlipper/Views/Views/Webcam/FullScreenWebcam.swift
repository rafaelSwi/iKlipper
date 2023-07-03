import SwiftUI

struct FullScreenWebcam: View {
    
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
            
            ZStack {
                
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: 635, height: 365)
                    .cornerRadius(15)
                
                webcam.stream
                    .resizable()
                    .frame(width: 620, height: 350)
                    .onAppear {
                        webcam.play (
                            url: URL(string: printerInfo.main.webcam)!,
                            timeInterval: settings.camPerformance.time
                        )
                    }
                
            } .rotationEffect(Angle(degrees: 90.0))
            
            Spacer()
            
            DefaultView.ReturnButton()
                .onTapGesture {
                    webcam.stop()
                    presentationMode.wrappedValue.dismiss()
                }
            
        }
        
    }
}
