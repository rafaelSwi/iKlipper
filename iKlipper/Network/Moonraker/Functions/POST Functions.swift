import Foundation
/*
final class POST {
    
    struct JSON <T: Codable> : Codable {
        var jsonrpc: String = "2.0"
        var method: String
        var id: Int
        var params: T?
        
        init (
            method: String,
            id: Int,
            params: T? = nil
        ) {
            self.method = method
            self.id = id
            self.params = params
        }
    }
    
    static func performRequest <T: Codable> (json: T, method: String, url: URL) async throws -> Bool {
        
        guard let encoded = try? JSONEncoder().encode(json) else {
            throw fatalError("[\(method)] FAILED TO ENCODE JSON.")
        }
    
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (_, response) = try await URLSession.shared.upload(for: request, from: encoded)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw fatalError("[\(method)] IMPOSSIBLE TO TRANSFORM RESPONSE INTO \"HTTPRESPONSE\".")
            }
            
            switch httpResponse.statusCode {
                case 200:       return true
                default:        return false
            }
        }
    }
    
    final class Printer {
        
        static func emergencyStop () async throws {
            
            let json = POST.JSON <String> (
                method: "printer.emergency_stop",
                id: 4564,
                params: nil
            )
            
            guard let encoded = try? JSONEncoder().encode(json) else {
                print ("[printer.emergency_stop] FAILED TO ENCODE")
                return
            }
            
            let url = URL(string: "\(PrinterInfo.host)/printer/emergency_stop")!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            do {
                let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
                print (data)
            }
            
        }
        
    }
    
    final class Print {
        
        static func pause () async throws -> Bool {
            
            let url = URL(string: "\(PrinterInfo.host)/printer/print/pause")!
            let json = POST.JSON <String> (
                method: "printer.print.pause",
                id: 4564,
                params: nil
            )
            
            return try await POST.performRequest(json: json, method: json.method, url: url)
            
        }
        
        static func resume () async throws -> Bool {
            
            let url = URL(string: "\(PrinterInfo.host)/printer/print/resume")!
            let json = POST.JSON <String> (
                method: "printer.print.resume",
                id: 1465,
                params: nil
            )
            
            return try await POST.performRequest(json: json, method: json.method, url: url)
            
        }
        
        static func cancel () async throws -> Bool {
            
            let url = URL(string: "\(PrinterInfo.host)/printer/print/cancel")!
            
            let json = POST.JSON <String> (
                method: "printer.print.cancel",
                id: 2578,
                params: nil
            )
            
            return try await POST.performRequest(json: json, method: json.method, url: url)
            
        }
        
        static func printfilename (_ filename: String) async throws -> Bool {
            
            let url = URL(string: "\(PrinterInfo.host)/printer/print/start?filename=\(filename)")!
            
            struct params: Codable {
                var filename: String
            }
            
            let json = POST.JSON (
                method: "printer.print.start",
                id: 4654,
                params: params(filename: filename)
            )
            
            return try await POST.performRequest(json: json, method: "printFilename", url: url)
    
        }
        
    }
    
    final class Machine {
        
        static func shutdown () async throws -> Bool {
            
            let url = URL(string: "\(PrinterInfo.host)/machine/shutdown")!
            let json = POST.JSON <String> (
                method: "machine.shutdown",
                id: 4665,
                params: nil
            )
            
            return try await POST.performRequest(json: json, method: json.method, url: url)
            
        }
        
        static func reboot () async throws -> Bool {
            
            let url = URL(string: "\(PrinterInfo.host)/machine/reboot")!
            let json = POST.JSON <String> (
                method: "machine.reboot",
                id: 4665,
                params: nil
            )
            
            return try await POST.performRequest(json: json, method: json.method, url: url)
        }
        
    }
    
    final class Server {
        
        static func restart () async throws -> Bool {
            
            let url = URL(string: "\(PrinterInfo.host)/server/restart")!
            let json = POST.JSON <String> (
                method: "server.restart",
                id: 4656,
                params: nil
            )
            
            return try await POST.performRequest(json: json, method: json.method, url: url)
            
        }
        
    }
    
}
*/
