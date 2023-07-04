import SwiftUI

struct PrintingScreen: View {
    
    @EnvironmentObject var printerInfo: PrinterInfo
    @Binding var state: PrinterState.State
    
    @State var viewCamera: Bool = false
    
    @State var temp: [String: [Double]] = [
        "extruder": [],
        "heater_bed": [],
    ]
    
    @State var printStats: PrintStats = PrintStats (image: UIImage(systemName: "cube")!, filePath: " ", fileSize: 0, fileName: " ", progress: 0, totalDuration: 0, printDuration: 0, filamentUsed: 0)
    
    @State var extruder = Temp(name: "Extruder", color: .red, icon: "arrowtriangle.down.fill")
    @State var heaterBed = Temp(name: "Heater Bed", color: .blue, icon: "bed.double.fill")
    
    var placeholder: some View {
        Image (systemName: "cube.transparent")
            .resizable()
            .frame(width: 200, height: 200)
            .padding(.all)
    }
    
    func beauty (_ string: String) -> String {
        var str = string
        let prefixes = ["SX1", "SX2"]
        for prefix in prefixes {
            if str.uppercased().hasPrefix(prefix) {
                for _ in 0...prefix.count {
                    str.removeFirst()
                }
            }
        }
        let components = str.components(separatedBy: ".")
        if components.count > 1 {
            str = components.dropLast().joined(separator: ".")
        }
        return str.capitalized
    }
    
    // n = Name; ic = icon; v = value; c = color;
    func infoDisplay (n: String, ic: String, v: Double, c: Color) -> some View {
        return VStack {
            HStack {
                Image(systemName: ic)
                Text(n)
                Spacer()
                Text ("\(Int(v))")
                    .font(.callout)
                    .padding(.horizontal)
            }
            .frame(width: 205, height: 20, alignment: .trailing)
            Rectangle()
                .frame(width: 205, height: 2)
                .foregroundColor(c)
        }
        .padding(.top)
    }
    
    var body: some View {
        
        var temperatures: [Temp] = [extruder, heaterBed]
        
        VStack {
            
            Text (beauty(printStats.fileName))
                .font(.title)
            
            if (printStats.image == UIImage(systemName: "cube")) {
                placeholder
            } else {
                Image(uiImage: printStats.image)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding(.all)
            }
            
            ForEach(temperatures) { tp in
                var value = tp.tempValues.last ?? 0.0
                infoDisplay(n: tp.name, ic: tp.icon, v: value, c: tp.color)
            }
            
            Spacer()
            
            HStack {
                
                DefaultView.Custom.IconTextButton (
                    text: "Pause",
                    systemName: "pause.fill",
                    w: 145,
                    h: 55,
                    cr: 12
                )
                .onTapGesture {
                    Task {
                        try await POST.Print.pause(pr: printerInfo.main)
                    }
                }
                
                DefaultView.Custom.IconTextButton (
                    text: "Cancel",
                    systemName: "xmark.circle.fill",
                    w: 145,
                    h: 55,
                    cr: 12
                )
                .onTapGesture {
                    Task {
                        try await POST.Print.cancel(pr: printerInfo.main)
                    }
                }
                
            }
            
            DefaultView.Custom.IconTextButton (
                text: "Open Camera",
                systemName: "camera.aperture",
                w: 290,
                h: 50,
                cr: 12
            )
            .onTapGesture {
                viewCamera.toggle()
            }
            
            
            .fullScreenCover(isPresented: $viewCamera) {
                WebcamView()
            }
            
            Spacer()
            
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { timer in
                Task {
                    let pr = printerInfo.main
                    state = try await pr.state()
                    extruder.tempValues = try await GET.Server.tempStore(pr: pr).extruder.temperatures
                    heaterBed.tempValues = try await GET.Server.tempStore(pr: pr).heaterBed.temperatures
                    printStats = try await GET.Machine.printStats(pr: pr)
                }
                temperatures = [extruder, heaterBed]
            }
        }
    }
}
