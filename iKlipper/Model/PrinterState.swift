import Foundation

struct PrinterState {
    
    enum State: String {
        case offline = "Offline"
        case operational = "Operational"
        case printing = "Printing"
    }
    
    var state: State
    
}
