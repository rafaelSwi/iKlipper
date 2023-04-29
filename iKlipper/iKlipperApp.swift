import SwiftUI

@main
struct iKlipperApp: App {
    
    @StateObject var printerInfo = PrinterInfo (
        printers: [],
        main: Printer(name: "No_Name", ip: "127.0.0.1", port: 80, https: false)
    )
    
    var body: some Scene {
        
        WindowGroup {
            NavigationView {
                BottomNavBar()
                    .preferredColorScheme(.dark)
                    .accentColor(.white)
                    .environmentObject(printerInfo)

            }
        }
        
    }
}
