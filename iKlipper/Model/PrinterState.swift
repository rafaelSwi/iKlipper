import Foundation

/// Represents the current printer state, used to define which View should be loaded.
struct PrinterState {
    
    enum State: String {
        case offline = "Offline"
        case operational = "Operational"
        case printing = "Printing"
    }
    
    var state: State
    
}
