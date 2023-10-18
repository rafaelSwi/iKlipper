import SwiftUI

struct AddNewPrinter: View {
    
    @Environment (\.presentationMode) var presentationMode
    
    @State var printer = Printer(name: "", ip: "", port: 80, https: false, model: .x1)
    
    @State private var models: [Printer.Model] = [.x1, .x2]
    
    @FocusState private var typingFocused: Bool
    
    @EnvironmentObject var printerInfo: PrinterInfo
    
    func emptyFields () -> Bool {
        if printer.name == "" || printer.ip == "" {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        
        Text (String(localized: "print.add_new.title"))
            .font(.system(size: 44))
            .padding(.all)
        
        Spacer ()
        
        Group {
            TextField(String(localized: "print.add_new.printer_name"), text: $printer.name)
                .focused($typingFocused)
                .textFieldStyle(AddPrinterTextFieldStyle())
                .padding(.top)
            Rectangle()
                .frame(width: 180, height: 1)
        }
        
        Group {
            TextField(String(localized: "print.add_new.printer_ip"), text: $printer.ip)
                .focused($typingFocused)
                .textFieldStyle(AddPrinterTextFieldStyle())
                .padding(.top)
            Rectangle()
                .frame(width: 180, height: 1)
        }
        
        Group {
            TextField(String(localized: "print.add_new.port"), value: $printer.port, format: .number)
                .focused($typingFocused)
                .textFieldStyle(AddPrinterTextFieldStyle())
                .keyboardType(.numberPad)
                .padding(.top)
            Rectangle()
                .frame(width: 70, height: 1)
                .padding(.bottom)
        }
        
        Group {
            Text (String(localized: "print.add_new.https"))
                .font(.subheadline)
                .padding(.top)
                .foregroundColor(.gray)
            Toggle(isOn: $printer.https) {
                EmptyView()
            }
            .labelsHidden()
            .toggleStyle(SwitchToggleStyle(tint: .blue))
            .padding(.all)
        }
        
        Group {
            Text (String(localized: "print.add_new.model"))
                .font(.system(size: 22))
                .fontWeight(.thin)
            Picker (String(localized: "print.add_new.model"), selection: $printer.model) {
                ForEach(models, id: \.self) { model in
                    Text ("\(model.rawValue)")
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 130)
        }
        
        Spacer()
        
        if !typingFocused {
            DefaultView.Custom.IconTextButton(text: String(localized: "print.add_new.add_printer"), systemName: "plus", w: 280, h: 40, cr: 28)
                .onTapGesture {
                    if !emptyFields() {
                        printerInfo.addPrinter(self.printer)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
        }
            
        DefaultView.ReturnButton()
            .onTapGesture {
                switch self.typingFocused {
                case true: self.typingFocused = false
                case false: presentationMode.wrappedValue.dismiss()
                }
            }
        
    }
}

fileprivate struct AddPrinterTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(width: 180, height: 27)
            .multilineTextAlignment(.center)
            .font(.system(size: 22))
            .fontWeight(.thin)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
    }
}
