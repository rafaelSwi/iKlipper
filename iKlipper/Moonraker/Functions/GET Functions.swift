import Foundation

final class GET {
    
    static func performRequest (method: String, url: URL) async throws -> Data {
    
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return data
        }
    }
    
    final class Server {
        
        static func filesList (pr: Printer) async throws -> [Network.AvailableFiles.Result] {
            
            let url = URL(string: "\(pr.host)/server/files/list")!
            print (pr.host)
            let data: Data = try await GET.performRequest(method: "server.files.list", url: url)

            let decodedData = try JSONDecoder().decode(Network.AvailableFiles.self, from: data)
            
            return decodedData.result
            
        }
        
        static func temperatureStore (pr: Printer) async throws -> Network.TemperatureStore.Result {
            
            let url = URL(string: "\(pr.host)/server/temperature_store")!
            
            let data: Data = try await GET.performRequest(method: "server.temperature_store", url: url)
            
            let decoder = JSONDecoder()

            let decodedData = try decoder.decode(Network.TemperatureStore.self, from: data)
            
            return decodedData.result
            
        }
        
        /*
        
        static func thumbnail (pr: Printer) async throws -> Data {
            
            // /server/files/thumbnails?filename={filename}
            
            // scx10012.local/server/files/thumbnails?filename=SX1_conjunto%20direção.gcode
            
        }
        
        */
        
    }
    
    final class API {
        
        static func jobStatus (pr: Printer) async throws -> Network.JobStatus {
            
            let url = URL(string: "\(pr.host)/api/job")!
            
            let data: Data = try await GET.performRequest(method: "api.job_status", url: url)
            
            let decoder = JSONDecoder()

            let decodedData = try decoder.decode(Network.JobStatus.self, from: data)
            
            return decodedData
            
        }
        
    }
    
    
}
 
