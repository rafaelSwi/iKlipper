import SwiftUI

struct MainScreen: View {
    
    @EnvironmentObject var printerInfo: PrinterInfo
    
    @State var wantToPrint: Bool = false
    
    @State var temp: [String: [Double]] = [
        "extruder": [],
        "heater_bed": [],
        "chamber_fan": []
    ]
    
    @State var extruder = Temp(name: "Extruder", color: .red, icon: "arrowtriangle.down.fill")
    @State var heaterBed = Temp(name: "Heater Bed", color: .blue, icon: "bed.double.fill")
    @State var chamberFan = Temp(name: "Chamber Fan", color: .green, icon: "wind.circle.fill")
    
    var body: some View {
        
        var temperatures: [Temp] = [extruder, heaterBed, chamberFan]
        
        VStack {
            
            Spacer ()
        
            
            
            ForEach(temperatures) { temperature in
                DefaultView.TemperatureRectangle(temperature: temperature)
            } .onAppear {
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
                    Task {
                        let pr = printerInfo.main
                        extruder.tempValues = try await GET.Server.temperatureStore(pr: pr).extruder.temperatures
                        heaterBed.tempValues = try await GET.Server.temperatureStore(pr: pr).heaterBed.temperatures
                        chamberFan.tempValues = try await GET.Server.temperatureStore(pr: pr).temperatureFan.temperatures
                    }
                    temperatures = [extruder, heaterBed, chamberFan]
                }
            }
            
            Button(action: {
                wantToPrint.toggle()
            }) {
                DefaultView.Custom.IconButton(systemName: "printer", w: 350, h: 70, cr: 28)
                    .padding(.all)
            }
            
            .fullScreenCover(isPresented: $wantToPrint) {
                SelectFileToPrint()
            }
            
        }
        
        
    }
    
    
}
