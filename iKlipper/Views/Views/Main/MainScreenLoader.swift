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
                    OperationalScreen()
                } else if state == .printing {
                    PrintingScreen()
                } else {
                    DefaultView.LoadingSpin()
                }
                
            }
            
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                Task {
                    state = try await printerInfo.main.state()
                }
            }
        }
    }
}
