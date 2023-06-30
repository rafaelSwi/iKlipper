import SwiftUI

@available(iOS 16.0, *)
struct BottomNavBar: View {
    
    var body: some View {
        
        NavigationView {
            
            TabView {

                Settings()
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
                
                MainScreen()
                    .tabItem {
                        Image(systemName: "cube.transparent")
                        Text("Print")
                    }
                
                PrintingScreen()
                    .tabItem {
                        Image(systemName: "hand.point.up.braille.fill")
                        Text("Control")
                    }
                
            }
        }
    }
}
