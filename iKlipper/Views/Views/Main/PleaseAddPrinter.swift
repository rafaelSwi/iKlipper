import SwiftUI

struct PleaseAddPrinter: View {
    
    @EnvironmentObject var printerInfo: PrinterInfo
    
    @State var viewPrintList: Bool = false
    @State var addNewPrinter: Bool = false
    
    var body: some View {
        
        HStack {
            
            Group {
                
                Image(systemName: "plus")
                    .resizable()
                
                Image(systemName: "printer")
                    .resizable()
                
            }
            .frame(width: 80, height: 80)
            .padding(.horizontal)
            
            
        }
        .padding(.all)
        
        Text(String(localized: "main.empty.add_printer_title"))
            .font(.system(size: 38).bold())
        
        Text (String(localized: "main.empty.add_and_activate"))
            .font(.subheadline)
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .padding(.bottom)
        
        VStack {
            
            DefaultView.Custom.IconTextButton (
                text: String(localized: "main.empty.printer_list"),
                systemName: "list.bullet.rectangle",
                w: 315,
                h: 65,
                cr: 30
            )
            .onTapGesture {
                viewPrintList.toggle()
            }
            .fullScreenCover(isPresented: $viewPrintList) {
                PrinterList()
            }
            
            DefaultView.Custom.IconTextButton (
                text: String(localized: "main.empty.add_printer"),
                systemName: "plus",
                w: 315,
                h: 45,
                cr: 30
            )
            .onTapGesture {
                addNewPrinter.toggle()
            }
            .fullScreenCover(isPresented: $addNewPrinter) {
                AddNewPrinter()
            }
        }
        .padding(.all)
    }
}
