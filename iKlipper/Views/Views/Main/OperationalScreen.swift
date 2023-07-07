import SwiftUI

struct OperationalScreen: View {
    
    @EnvironmentObject var printerInfo: PrinterInfo
    @Binding var state: PrinterState.State
    
    @State var wantToPrint: Bool = false
    @State var wantToViewCam: Bool = false
    
    @State var temp: [String: [Double]] = [
        "extruder": [],
        "heater_bed": [],
        "chamber_fan": []
    ]
    
    @State var extruder = DisplayableInfo(name: "Extruder", color: .red, icon: "flame.fill", tag: "°")
    @State var heaterBed = DisplayableInfo(name: "Heater Bed", color: .blue, icon: "bed.double.fill", tag: "°")
    @State var chamberFan = DisplayableInfo(name: "Chamber Fan", color: .green, icon: "wind.circle.fill", tag: "°")
    
    func statusColor (_ color: Color, _ status: PrinterState.State) -> Color {
        if status == .offline {
            return .gray
        } else {
            return color
        }
    }
    
    func temperatureRectangle (temperature: DisplayableInfo) -> some View {
        return ZStack {
            Rectangle()
                .frame(width: 350, height: 78)
                .foregroundColor(statusColor(temperature.color, state))
                .blur(radius: 25)
                .opacity(0.1)
            
            HStack {
                Rectangle()
                    .frame(width: 9, height: 78)
                    .foregroundColor(statusColor(temperature.color, state))
                Text (temperature.name)
                    .font(.system(size: 28).bold())
                    .padding(.horizontal)
                Spacer()
                Text ("\(Int(temperature.values.last ?? 0.0))")
                    .font(.system(size: 28))
                    .padding(.trailing)
            }
        }
    }
    
    var body: some View {
        
        var temperatures: [DisplayableInfo] = [extruder, heaterBed, chamberFan]
        
        VStack {
            
            Spacer ()
                .frame(height: 15)
            
            ForEach(temperatures) { temperature in
                temperatureRectangle(temperature: temperature)
            } .onAppear {
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
                    Task {
                        let pr = printerInfo.main
                        state = try await pr.state()
                        extruder.values = try await GET.Server.tempStore(pr: pr).extruder.temperatures
                        heaterBed.values = try await GET.Server.tempStore(pr: pr).heaterBed.temperatures
                        chamberFan.values = try await GET.Server.tempStore(pr: pr).temperatureFan.temperatures
                    }
                    temperatures = [extruder, heaterBed, chamberFan]
                }
            }
            
            Spacer()
            
            DefaultView.Custom.IconTextButton (
                text: "Camera",
                systemName: "camera.aperture",
                w: 235,
                h: 45,
                cr: 28
            )
            .onTapGesture {
                wantToViewCam.toggle()
            }
            .fullScreenCover(isPresented: $wantToViewCam) {
                WebcamView()
            }
            
            DefaultView.Custom.IconButton(systemName: "printer", w: 350, h: 70, cr: 28)
                .padding(.all)
                .onTapGesture {
                    wantToPrint.toggle()
                }
            
                .fullScreenCover(isPresented: $wantToPrint) {
                    FileFetch()
                }
        }
    }
}
