import Foundation
import SwiftUI

struct Temp: Identifiable {
    var name: String
    var tempValues: [Double] = []
    var color: Color
    var icon: String
    var id: UUID = UUID()
}
