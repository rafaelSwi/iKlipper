import Foundation
import SwiftUI

/// It stores the most relevant information of a Job in progress.
struct PrintStats {
    
    var image: UIImage
    
    var filePath: String
    var fileSize: Double
    var fileName: String
    
    var progress: Double
    var totalDuration: Double
    var printDuration: Double
    var filamentUsed: Double
    
}
