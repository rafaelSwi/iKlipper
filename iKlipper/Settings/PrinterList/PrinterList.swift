import SwiftUI

struct PrinterList: View {
    
    @Environment (\.presentationMode) var presentationMode
    
    @State var wantToEditPrinter: Bool = false
    
    @EnvironmentObject var printerInfo: PrinterInfo
    
    @State var selectedPrinter: Printer = Printer (
        name: "NO_NAME",
        ip: "NO_IP",
        port: 0,
        https: false
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
            
            Text ("Printers")
                .font(.system(size: 50))
            
            Text ("Active: \(activeName)")
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
                        
                    } .frame(height: 50)
                    
                }
            }
            
            .fullScreenCover(isPresented: $wantToEditPrinter) {
                EditPrinter(printer: selectedPrinter)
            }
            
            Spacer ()
            
            DefaultView.Custom.IconTextButton (
                text: "Add Printer with Random ID",
                systemName: "flag.checkered.circle.fill",
                w: 205,
                h: 78,
                cr: 34
            )
            .onTapGesture {
                printerInfo.addPrinter(Printer(name: "PD01", ip: "172.16.0.13", port: 80, https: false))
            }
            
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
            
            Button (action: {
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
                printerInfo.overwriteMainPrinterWith(self.printer)
            }) {
                DefaultView.Custom.IconButton (
                    systemName: printerInfo.isMain(printer) ? "plus.diamond.fill" : "plus.diamond",
                    w: 75,
                    h: 50,
                    cr: 12
                )
            }
            
        } .frame(height: 50)
        
    }
}
