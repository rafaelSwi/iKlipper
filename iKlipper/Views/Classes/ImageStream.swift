import Foundation
import SwiftUI

@MainActor
final class ImageStream: ObservableObject {
    
    /// The Image which will be constantly updated
    @Published var stream: Image = Image("player")
    
    @Published var run: Bool = false
    
    @MainActor func play (url: URL, timeInterval: Double) {
        self.run = true
        let timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { timer in
            let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
                if let data = data {
                    DispatchQueue.main.async {
                        let dataAsUiImage = UIImage(data: data) ?? UIImage(systemName: "viewfinder")!
                        self.stream = Image(uiImage: dataAsUiImage)
                    }
                }
            }
            if self.run {
                task.resume()
            } else {
                timer.invalidate()
            }
        }
    }
    
    @MainActor func stop () {
        self.run = false
    }
    
    init () {}
    
}
