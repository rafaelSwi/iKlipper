import Foundation

final public class Printer: ObservableObject, Identifiable {
    
    enum Model: String, Hashable {
        case x1 = "X1"
        case x2 = "X2"
    }
    
    @Published var name: String
    
    @Published var ip: String
    
    @Published var port: Int
    
    @Published var https: Bool
    
    @Published var model: Model
    
    @Published public var id: UUID = UUID()
    
    func state () async throws -> PrinterState.State {
        
        var printer_state = try await GET.API.jobStatus(pr: self).state
        
        switch printer_state {
            
        case PrinterState.State.operational.rawValue:
            return PrinterState.State.operational
        case PrinterState.State.printing.rawValue:
            return PrinterState.State.printing
        default:
            return PrinterState.State.offline
            
        }
        
    }
    
    var host: String {
        switch self.https {
        case true:  return "https://\(self.ip)"
        case false: return "http://\(self.ip)"
        }
    }
    
    var webcam: String {
        switch self.https {
        case true:  return "https://\(self.ip)/webcam/?action=snapshot"
        case false: return "http://\(self.ip)/webcam/?action=snapshot"
        }
    }
    
    init (name: String, ip: String, port: Int, https: Bool, model: Model) {
        self.name = name
        self.ip = ip
        self.port = port
        self.https = https
        self.model = model
    }
    
}
