import SwiftUI

struct MainScreen: View {
    
    @State var wantToPrint: Bool = false
    
    @State var value: [Double] = [5.5, 4.0]
    
    var body: some View {
        
        VStack {
            
            Spacer ()
            
            Text ("TEMP: \(value[0])")
                .onAppear(perform: {
                    Task {
                        // value = try await GET.Server.temperatureStore().temperatureFan.temperatures
                    }
                })

            
            Button(action: {
                wantToPrint.toggle()
            }) {
                DefaultView.Custom.IconButton(systemName: "printer", w: 350, h: 70, cr: 28)
                    .padding(.all)
            }
            
            .fullScreenCover(isPresented: $wantToPrint) {
                // SelectFileToPrint()
            }
            
        }
        
        
    }
    
    
}
