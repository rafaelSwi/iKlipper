import Foundation

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
    
    final class Print {
        
        static func pause (pr: Printer) async throws -> Bool {
            
            let url = URL(string: "\(pr.host)/printer/print/pause")!
            let json = POST.JSON <String> (
                method: "printer.print.pause",
                id: 4564,
                params: nil
            )
            
            return try await POST.performRequest(json: json, method: json.method, url: url)
            
        }
        
        static func resume (pr: Printer) async throws -> Bool {
            
            let url = URL(string: "\(pr.host)/printer/print/resume")!
            let json = POST.JSON <String> (
                method: "printer.print.resume",
                id: 1465,
                params: nil
            )
            
            return try await POST.performRequest(json: json, method: json.method, url: url)
            
        }
        
        static func cancel (pr: Printer) async throws -> Bool {
            
            let url = URL(string: "\(pr.host)/printer/print/cancel")!
            
            let json = POST.JSON <String> (
                method: "printer.print.cancel",
                id: 2578,
                params: nil
            )
            
            return try await POST.performRequest(json: json, method: json.method, url: url)
            
        }
        
        static func printfilename (_ filename: String, pr: Printer) async throws -> Bool {
            
            let url = URL(string: "\(pr.host)/printer/print/start?filename=\(filename)")!
            
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
        
        static func sendGCode (_ gcode: String, pr: Printer) async throws {
            
            let json = POST.JSON <String> (
                method: "printer.gcode.script",
                id: 7466,
                params: nil
            )
            
            guard let encoded = try? JSONEncoder().encode(json) else {
                print ("[printer.sendGCode] FAILED TO ENCODE")
                return
            }
            
            var components = URLComponents(string: "\(pr.host)")!
            components.path = "/printer/gcode/script"
            components.queryItems = [
                URLQueryItem(name: "script", value: "\(gcode)"),
            ]
            if let url = components.url {
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                do {
                    let (_, _) = try await URLSession.shared.upload(for: request, from: encoded)
                }
            }
            
        }
        
        static func emergencyStop (pr: Printer) async throws {
            
            let json = POST.JSON <String> (
                method: "printer.emergency_stop",
                id: 4564,
                params: nil
            )
            
            guard let encoded = try? JSONEncoder().encode(json) else {
                print ("[printer.emergency_stop] FAILED TO ENCODE")
                return
            }
            
            let url = URL(string: "\(pr.host)/printer/emergency_stop")!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            do {
                let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
                print (data)
            }
            
        }
        
        static func shutdown (pr: Printer) async throws -> Bool {
            
            let url = URL(string: "\(pr.host)/machine/shutdown")!
            let json = POST.JSON <String> (
                method: "machine.shutdown",
                id: 4665,
                params: nil
            )
            
            return try await POST.performRequest(json: json, method: json.method, url: url)
            
        }
        
        static func reboot (pr: Printer) async throws -> Bool {
            
            let url = URL(string: "\(pr.host)/machine/reboot")!
            let json = POST.JSON <String> (
                method: "machine.reboot",
                id: 4665,
                params: nil
            )
            
            return try await POST.performRequest(json: json, method: json.method, url: url)
        }
        
    }
    
    final class Server {
        
        static func restart (pr: Printer) async throws -> Bool {
            
            let url = URL(string: "\(pr.host)/server/restart")!
            let json = POST.JSON <String> (
                method: "server.restart",
                id: 4656,
                params: nil
            )
            
            return try await POST.performRequest(json: json, method: json.method, url: url)
            
        }
        
    }
    
}

