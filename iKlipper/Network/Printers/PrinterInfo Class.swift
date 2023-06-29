import Foundation

final public class PrinterInfo: ObservableObject {
    
    @Published var printers: [Printer]
    
    @Published var main: Printer
    
    init(printers: [Printer], main: Printer) {
        self.printers = printers
        self.main = main
    }
    
    func isMain (_ printer: Printer) -> Bool {
        if printer.id == main.id && printer.name == main.name {
            return true
        } else {
            return false
        }
    }
    
    func overwriteMainPrinterWith (_ printer: Printer) {
        self.main = printer
    }
    
    func addPrinter (_ printer: Printer) {
        self.printers.append(printer)
    }
    
    func editPrinter (_ printer: Printer) {
        if let index = printers.firstIndex(where: { $0.id == printer.id }) {
            printers[index].name = printer.name
            printers[index].ip = printer.ip
            printers[index].port = printer.port
            printers[index].https = printer.https
            printers[index].id = printer.id
            printers[index].model = printer.model
        }
    }
    
    func rmPreviousAddNew (_ printer: Printer) {
        if let index = printers.firstIndex(where: { $0.id == printer.id }) {
            self.removePrinter(printers[index])
            self.addPrinter(printer)
        }
    }
    
    func removePrinter (_ printer: Printer) {
        if let index = printers.firstIndex(where: { $0.id == printer.id }) {
            printers.remove(at: index)
        }
    }
    
}

