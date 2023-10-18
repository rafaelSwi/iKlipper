import SwiftUI

struct Settings: View {
    
    @EnvironmentObject var settings: MainSettings
    @EnvironmentObject var printerInfo: PrinterInfo
    
    @State var viewPrintList: Bool = false
    @State var addNewPrinter: Bool = false
    
    var body: some View {
        
        
        VStack {
            
            ScrollView {
                
                HStack {
                    
                    DefaultView.Custom.IconTextButton (
                        text: String(localized: "settings.printers.title"),
                        systemName: "list.bullet.rectangle",
                        w: 250,
                        h: 65,
                        cr: 30
                    )
                    .onTapGesture {
                        viewPrintList.toggle()
                    }
                    .fullScreenCover(isPresented: $viewPrintList) {
                        PrinterList()
                    }
                    
                    DefaultView.Custom.IconButton (
                        systemName: "plus",
                        w: 65,
                        h: 65,
                        cr: 8
                    )
                        .onTapGesture {
                            addNewPrinter.toggle()
                        }
                        .fullScreenCover(isPresented: $addNewPrinter) {
                            AddNewPrinter()
                        }
                    
                }
                
                Text (String(localized: "settings.webcamperf.title"))
                    .font(.title)
                    .offset(y: 52)
                
                Picker(String(localized: "settings.webcamperf.title"), selection: $settings.camPerformance) {
                    ForEach(MainSettings.camOptions, id: \.self) { option in
                        Text ("\(option.name)")
                    }
                }
                .pickerStyle(.wheel)
                
                Text ("\(settings.camPerformance.description)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
            }
        }
    }
}
