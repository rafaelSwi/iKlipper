import SwiftUI

struct MainScreenLoader: View {
    
    @EnvironmentObject var printerInfo: PrinterInfo
    
    @State var state: PrinterState.State = .offline
    
    var body: some View {
        
        Group {
            
            VStack {
                
                if printerInfo.main.name == "No_Name" {
                    PleaseAddPrinter()
                } else if state == .offline {
                    OfflinePrinter()
                } else if state == .operational {
                    OperationalScreen(state: $state)
                } else if state == .printing {
                    PrintingScreen(state: $state)
                } else {
                    DefaultView.LoadingSpin()
                }
                
            }
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 2.2, repeats: true) { timer in
                    print ("MAINSCREENLOADER_TAB: TIMER RUN.")
                    Task {
                        state = try await printerInfo.main.state()
                    }
                    if state != .offline {
                        timer.invalidate()
                        print ("MAINSCREENLOADER_TAB: TIMER OFFLINE!")
                    }
                }
            }
        }
    }
}
