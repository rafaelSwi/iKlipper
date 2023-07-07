import Foundation

/// Represents the current printer state, used to define which View should be loaded.
struct PrinterState {
    
    enum State: String {
        case offline = "Offline"
        case operational = "Operational"
        case printing = "Printing"
        case paused = "Paused"
        case error = "Error"
        case cancelled = "Cancelled"
        case standyby = "Standby"
    }
    
    var state: State
    
}
