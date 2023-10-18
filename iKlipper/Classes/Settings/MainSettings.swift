import Foundation
import SwiftUI

/// Class where it stores the Application's main settings, which can be modified by the user
final public class MainSettings: ObservableObject {
    
    struct WebcamPerformance: Hashable {
        var time: Double
        var name: String
        var description: String
    }
    
    static var camOptions: [WebcamPerformance] = [
        WebcamPerformance (
            time: 1.1,
            name: String(localized: "settings.webcamperf.slow.title"),
            description: String(localized: "settings.webcamperf.slow.desc")
        ),
        WebcamPerformance (
            time: 0.45,
            name: String(localized: "settings.webcamperf.normal.title"),
            description: String(localized: "settings.webcamperf.normal.desc")
        ),
        WebcamPerformance (
            time: 0.25,
            name: String(localized: "settings.webcamperf.fast.title"),
            description: String(localized: "settings.webcamperf.fast.desc")
        ),
        WebcamPerformance (
            time: 0.1,
            name: String(localized: "settings.webcamperf.max.title"),
            description: String(localized: "settings.webcamperf.max.desc")
        ),
    ]
    
    @Published var camPerformance: WebcamPerformance = MainSettings.camOptions[1]
    
}
