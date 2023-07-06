import Foundation
import SwiftUI

/// Created with intent to display a specific Temperature with custom icons and colors, mainly used in "OperationalScreen" View.
struct Temp: Identifiable {
    
    var name: String
    var tempValues: [Double] = []
    var color: Color
    var icon: String
    var id: UUID = UUID()
    
}
