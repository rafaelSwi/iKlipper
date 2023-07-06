import Foundation

final class Converter {
    
    static func progress (_ value: Double) -> Int {
        
        let slash = Int(value * 100)
        let result = slash % 100
        return result
        
    }
    
}
