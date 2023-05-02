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
            
            let data: Data = try await GET.performRequest(method: "server.files.list", url: url)

            let decodedData = try JSONDecoder().decode(Network.AvailableFiles.self, from: data)
            
            return decodedData.result
            
        }
        
        static func temperatureStore (pr: Printer) async throws -> Network.TemperatureStore.Result {
            
            let url = URL(string: "\(pr.host)/server/temperature_store")!
            
            let data: Data = try await GET.performRequest(method: "server.temperature_store", url: url)
            
            let decoder = JSONDecoder()
            
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            let decodedData = try decoder.decode(Network.TemperatureStore.self, from: data)
            
            print ("[*] INFO: \(decodedData.result.temperatureFan.temperatures)")
            
            return decodedData.result
            
        }
        
    }
    
    
}
 
