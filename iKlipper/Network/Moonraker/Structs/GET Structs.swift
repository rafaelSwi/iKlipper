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
        
        struct Extruder: Codable {
            let temperatures: [Double]
            let targets: [Double]
            let powers: [Double]
        }

        struct TemperatureFan: Codable {
            let temperatures: [Double]
            let targets: [Double]
            let speeds: [Double]
        }

        struct TemperatureSensor: Codable {
            let temperatures: [Double]
        }

        struct Result: Codable {
            let extruder: Extruder
            let temperatureFan: TemperatureFan
            let temperatureSensor: TemperatureSensor
        }
        
        let result: Result
        
    }
    
}

