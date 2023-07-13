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
        
        var rectanglewidth: CGFloat {
            DeviceModel.deviceClassification() == .small ? 565 : 635
        }
        
        var rectangleHeight: CGFloat {
            DeviceModel.deviceClassification() == .small ? 324 : 365
        }
        
        VStack {
            
            Spacer()
            
            ZStack {
                
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: rectanglewidth, height: rectangleHeight)
                    .cornerRadius(15)
                
                webcam.stream
                    .resizable()
                    .frame(width: (rectanglewidth - 19), height: (rectangleHeight - 19))
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
