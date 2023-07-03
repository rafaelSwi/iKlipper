import SwiftUI

struct Move: View {
    
    @Environment (\.presentationMode) var presentationMode
    
    @EnvironmentObject var settings: MainSettings
    @EnvironmentObject var printerInfo: PrinterInfo
    
    @ObservedObject var webcam = ImageStream()
    
    var body: some View {
        
        VStack {
            
            Text ("MOVE TAB")
            
        }
        
    }
}
