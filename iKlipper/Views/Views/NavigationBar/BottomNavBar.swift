import SwiftUI

@available(iOS 16.0, *)
struct BottomNavBar: View {
    
    var body: some View {
        
        NavigationView {
            
            TabView {
                
                Settings()
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text(String(localized: "bottomnavbar.settings"))
                    }
                
                MainScreenLoader()
                    .tabItem {
                        Image(systemName: "cube.transparent")
                        Text(String(localized: "bottomnavbar.printer"))
                    }
            }
        }
    }
}
