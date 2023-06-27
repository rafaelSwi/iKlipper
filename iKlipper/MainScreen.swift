import SwiftUI

struct MainScreen: View {
    
    @EnvironmentObject var printerInfo: PrinterInfo
    
    @State var wantToPrint: Bool = false
    
    @State var temp: [String: [Double]] = [
        "extruder": [],
        "heater_bed": [],
        "chamber_fan": []
    ]
    
    struct Temp: Identifiable {
        var name: String
        var tempValues: [Double] = [0.0]
        var color: Color
        var icon: String
        var id: UUID = UUID()
    }
    
    @State var extruder = Temp(name: "Extruder", color: .red, icon: "arrowtriangle.down.fill")
    @State var heaterBed = Temp(name: "Heater Bed", color: .blue, icon: "bed.double.fill")
    @State var chamberFan = Temp(name: "Chamber Fan", color: .green, icon: "wind.circle.fill")
    
    var body: some View {
        
        var temperatures: [Temp] = [extruder, heaterBed, chamberFan]
        
        VStack {
            
            Spacer ()
            
            ForEach(temperatures) { temperature in
                HStack {
                    Rectangle()
                        .frame(width: 9, height: 78)
                        .foregroundColor(temperature.color)

                    Text (temperature.name)
                        .font(.system(size: 28).bold())
                        .padding(.horizontal)
                    Text ("\(Int(temperature.tempValues.last!))")
                        .font(.system(size: 28))
                    Spacer()
                }
            } .onAppear {
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
                    Task {
                        extruder.tempValues = try await GET.Server.temperatureStore(pr: printerInfo.main).extruder.temperatures
                        heaterBed.tempValues = try await GET.Server.temperatureStore(pr: printerInfo.main).heaterBed.temperatures
                        chamberFan.tempValues = try await GET.Server.temperatureStore(pr: printerInfo.main).temperatureFan.temperatures
                    }
                    temperatures = [extruder, heaterBed, chamberFan]
                    print ("hello :)")
                }
            }
            
            /*
            Text ("HEATER BED: \(Temp.heaterBed[0])")
                .onAppear(perform: {
                    Task {
                        heaterBedTemp = try await GET.Server.temperatureStore(pr: printerInfo.main).heaterBed.temperatures
                    }
                })
             */
            
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
