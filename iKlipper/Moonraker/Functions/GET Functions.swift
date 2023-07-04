import Foundation
import SwiftUI

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
        
        static func tempStore (pr: Printer) async throws -> Network.TemperatureStore.Result {
            
            let url = URL(string: "\(pr.host)/server/temperature_store")!
            
            let data: Data = try await GET.performRequest(method: "server.temperature_store", url: url)
            
            let decoder = JSONDecoder()
            
            let decodedData = try decoder.decode(Network.TemperatureStore.self, from: data)
            
            return decodedData.result
            
        }
        
        static func thumbnail (pr: Printer, filename: String) async throws -> Data {
            
            var fname = filename
            fname = fname.replacingOccurrences(of: " ", with: "%20")
            print (fname)
            
            let components = fname.components(separatedBy: ".")
            if components.count > 1 {
                fname = components.dropLast().joined(separator: ".")
            }
            
            fname = (fname + ".png")
            
            let url = URL(string: "\(pr.host)/server/files/gcodes/.thumbs/\(fname)")!
            print (url)
            
            return try await URLSession.shared.data(from: url).0
            
        }
        
    }
    
    final class Machine {
        
        static func printStats (pr: Printer) async throws -> PrintStats {
            
            let url = URL(string: "\(pr.host)/printer/objects/query?webhooks&virtual_sdcard&print_stats")!
            
            let data: Data = try await GET.performRequest(method: "printer.objects.query", url: url)
            
            let decoder = JSONDecoder()
            
            let dcdData = try decoder.decode(Network.PrintStats.self, from: data)
            
            let filename = dcdData.result.status.print_stats.filename
            
            let thumbnail = try await GET.Server.thumbnail(pr: pr, filename: filename)
            
            let printStats = PrintStats (
                image: (UIImage(data: thumbnail) ?? UIImage(systemName: "cube.fill"))!,
                filePath: dcdData.result.status.virtual_sdcard.file_path,
                fileSize: dcdData.result.status.virtual_sdcard.file_size,
                fileName: filename,
                progress: dcdData.result.status.virtual_sdcard.progress,
                totalDuration: dcdData.result.status.print_stats.total_duration,
                printDuration: dcdData.result.status.print_stats.print_duration,
                filamentUsed: dcdData.result.status.print_stats.filament_used
            )
            
            return printStats
        }
        
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

