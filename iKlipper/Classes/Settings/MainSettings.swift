import Foundation

final public class MainSettings: ObservableObject {
    
    struct WebcamPerformance: Hashable {
        var time: Double
        var name: String
        var description: String
    }
    
    static var camOptions: [WebcamPerformance] = [
        WebcamPerformance (
            time: 1.1,
            name: "Slow",
            description: "Recommended for poor Internet connections."
        ),
        WebcamPerformance (
            time: 0.45,
            name: "Normal",
            description: "Decent performance with low data usage."
        ),
        WebcamPerformance (
            time: 0.25,
            name: "Fast",
            description: "Slightly better than Normal."
        ),
        WebcamPerformance (
            time: 0.1,
            name: "Max",
            description: "Use as much data as possible."
        ),
    ]
    
    @Published var camPerformance: WebcamPerformance = MainSettings.camOptions[1]
    
}
