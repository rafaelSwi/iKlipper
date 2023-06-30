import SwiftUI

struct PrintingScreen: View {
    
    @EnvironmentObject var printerInfo: PrinterInfo
    
    @State var viewCamera: Bool = false
    
    var body: some View {
        
        VStack {
            
            Text ("Time Left: TIME")
                .font(.system(size: 35))
            
            // PRINTING THUMB IMAGE PLACEHOLDER
            Rectangle()
                .frame(width: 200, height: 200)
                .foregroundColor(.white)
                .padding(.all)
            
            Group {
                
                HStack {
                    Image(systemName: "clock.fill")
                    Text ("ELAPSED TIME")
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "water.waves")
                    Text ("TABLE TEMP.")
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "mount.fill")
                    Text ("EXTRUDER TEMP.")
                    Spacer()
                }
                
            } .frame(width: 210, height: 35)
            
            Spacer()
            
            HStack {
                
                DefaultView.Custom.IconTextButton (
                    text: "Pause",
                    systemName: "pause.fill",
                    w: 145,
                    h: 55,
                    cr: 12
                )
                .onTapGesture {
                    Task {
                        try await POST.Print.pause(pr: printerInfo.main)
                    }
                }
                
                DefaultView.Custom.IconTextButton (
                    text: "Cancel",
                    systemName: "xmark.circle.fill",
                    w: 145,
                    h: 55,
                    cr: 12
                )
                .onTapGesture {
                    Task {
                        try await POST.Print.cancel(pr: printerInfo.main)
                    }
                }
                
            }
            
            DefaultView.Custom.IconTextButton (
                text: "Open Camera",
                systemName: "camera.aperture",
                w: 290,
                h: 50,
                cr: 12
            )
            .onTapGesture {
                viewCamera.toggle()
            }
            
            
            .fullScreenCover(isPresented: $viewCamera) {
                WebcamView()
            }
            
            Spacer()
            
        }
    }
}
