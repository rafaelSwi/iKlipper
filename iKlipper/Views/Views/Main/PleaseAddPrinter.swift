import SwiftUI

struct PleaseAddPrinter: View {
    
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
            
            Text("Add a Printer")
                .font(.system(size: 38).bold())
            
            Text ("Add a Printer and mark it as active.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.bottom)
            
            VStack {
                
                DefaultView.Custom.IconTextButton (
                    text: "Printer List",
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
                    text: "Add Printer",
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
