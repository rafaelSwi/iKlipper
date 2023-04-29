import Foundation

final public class Printer: ObservableObject, Identifiable {
    
    @Published var name: String
    
    @Published var ip: String
    
    @Published var port: Int
    
    @Published var https: Bool
    
    @Published public var id: UUID = UUID()
    
    func host () -> String {
        switch self.https {
        case true:  return "https://\(self.ip)"
        case false: return "http://\(self.ip)"
        }
    }
    
    init (name: String, ip: String, port: Int, https: Bool) {
        self.name = name
        self.ip = ip
        self.port = port
        self.https = https
    }
    
}
