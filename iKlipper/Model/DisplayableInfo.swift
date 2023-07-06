import Foundation
import SwiftUI

/// Created with intent to display a specific Info with custom icons, colors, and a tag.
struct DisplayableInfo: Identifiable {
    
    var name: String
    var values: [Double] = []
    var color: Color
    var icon: String
    var tag: String
    var id: UUID = UUID()
    
}
