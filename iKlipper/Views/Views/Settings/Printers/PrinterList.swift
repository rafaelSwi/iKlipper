import SwiftUI

struct PrinterList: View {
    
    @Environment (\.presentationMode) var presentationMode
    
    @State var wantToEditPrinter: Bool = false
    
    @EnvironmentObject var printerInfo: PrinterInfo
    
    @State var selectedPrinter: Printer = Printer (
        name: "NO_NAME",
        ip: "NO_IP",
        port: 0,
        https: false,
        model: .x1
    )
    
    @State var mainPrinterId: UUID = UUID()
    
    func replaceSelectedPrinter (_ printer: Printer) {
        selectedPrinter.name = printer.name
        selectedPrinter.ip = printer.ip
        selectedPrinter.port = printer.port
        selectedPrinter.https = printer.https
        selectedPrinter.id = printer.id
    }
    
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
            
            Text (String(localized: "settings.printers.title"))
                .font(.system(size: 50))
            
            Text ("\(String(localized: "settings.printers.active")) \(activeName)")
                .font(.system(size: 19))
                .foregroundColor(.gray)
            
            ScrollView {
                
                ForEach (printerInfo.printers) { indexPrinter in
                    
                    HStack {
                        
                        Image(systemName: "printer")
                        
                        Text (indexPrinter.name)
                        
                        Spacer()
                        
                        Button (action: {
                            replaceSelectedPrinter(indexPrinter)
                            wantToEditPrinter.toggle()
                        }) {
                            DefaultView.Custom.IconButton (
                                systemName: "pencil",
                                w: 50,
                                h: 50,
                                cr: 12
                            )
                        }
                        
                        Button (action: {
                            printerInfo.overwriteMainPrinterWith(indexPrinter)
                        }) {
                            switch printerInfo.isMain(indexPrinter) {
                            case true:
                                DefaultView.Custom.IconButton(systemName: "plus.diamond.fill", w: 75, h: 50, cr: 12)
                            case false:
                                DefaultView.Custom.IconButton(systemName: "plus.diamond", w: 75, h: 50, cr: 12)
                            }
                        }
                    }
                    .frame(height: 50)
                    .padding(.horizontal)
                }
            }
            
            .fullScreenCover(isPresented: $wantToEditPrinter) {
                EditPrinter(printer: selectedPrinter)
            }
            
            Spacer ()
            
            DefaultView.ReturnButton()
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
        }
    }
}

fileprivate struct PrinterBox: View {
    
    @State var printer: Printer
    
    @Binding var wantToEditPrinter: Bool
    
    @EnvironmentObject var printerInfo: PrinterInfo
    
    var body: some View {
        
        HStack {
            
            Image(systemName: "printer")
            
            Text (self.printer.name)
            
            Spacer()
            
            DefaultView.Custom.IconButton (
                systemName: "pencil",
                w: 50,
                h: 50,
                cr: 12
            )
            .onTapGesture {
                wantToEditPrinter.toggle()
            }
            
            Button (action: {
                printerInfo.overwriteMainPrinterWith(self.printer)
            }) {
                DefaultView.Custom.IconButton (
                    systemName: printerInfo.isMain(printer) ? "plus.diamond.fill" : "plus.diamond",
                    w: 75,
                    h: 50,
                    cr: 12
                )
            }
            
        }
        .frame(height: 50)
    }
}
