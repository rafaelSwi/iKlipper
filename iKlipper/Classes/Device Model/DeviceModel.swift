import Foundation
import SwiftUI

final class DeviceModel {
    
    enum Classification {
        case small
        case normal
    }
    
    static var currentModel: String = UIDevice.current.name
    
    static func deviceClassification () -> DeviceModel.Classification {
        
        let small = [
            "iPhone SE",
            "iPhone 8",
            "iPhone 7"
        ]
        
        for term in small {
            if DeviceModel.currentModel.hasPrefix(term) {
                return .small
            }
        }
        return .normal
    }
}
