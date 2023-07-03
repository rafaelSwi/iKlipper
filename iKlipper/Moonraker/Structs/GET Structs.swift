import Foundation

final class Network {
    
    struct AvailableFiles: Codable {
        
        struct Result: Codable, Identifiable {
            let path: String
            let modified: Double
            let size: Int
            let permissions: String
            let id = UUID()
        }
        
        let result: [Result]
        
    }
    
    struct TemperatureStore: Codable {
        
        struct Result: Codable {
            
            struct HeaterBed: Codable {
                let temperatures: [Double]
                let targets: [Double]
                let powers: [Double]
            }
            
            struct TemperatureFan: Codable {
                let temperatures: [Double]
                let targets: [Double]
                let speeds: [Double]
            }
            
            struct Extruder: Codable {
                let temperatures: [Double]
                let targets: [Double]
                let powers: [Double]
            }
            
            let heaterBed: HeaterBed
            let temperatureFan: TemperatureFan
            let extruder: Extruder
            
            enum CodingKeys: String, CodingKey {
                case heaterBed = "heater_bed"
                case temperatureFan = "temperature_fan chamber_fan"
                case extruder = "extruder"
            }
            
        }
        
        let result: Result
        
    }
    
    struct JobStatus: Codable {
        
        struct Job: Codable {
            
            struct File: Codable {
                let name: String?
            }
            struct Filament: Codable {
                let length: Double?
            }
            let file: File
            let estimatedPrintTime: Double?
            let filament: Filament
            let user: String?
            
        }
        
        struct Progress: Codable {
            let completion: Double?
            let filepos: Int?
            let printTime: Int?
            let printTimeLeft: Int?
            let printTimeOrigin: String?
        }
        let job: Job
        let progress: Progress
        let state: String
        
    }
    
}

/*
 {
     "job": {
         "file": {"name": null},
         "estimatedPrintTime": null,
         "filament": {"length": null},
         "user": null
     },
     "progress": {
         "completion": null,
         "filepos": null,
         "printTime": null,
         "printTimeLeft": null,
         "printTimeOrigin": null
     },
     "state": "Offline"
 }
 */
