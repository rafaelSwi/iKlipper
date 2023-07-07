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
    
    @State var progress = DisplayableInfo(name: "Progress", color: .white, icon: "figure.run", tag: "%")
    @State var extruder = DisplayableInfo(name: "Extruder", color: .red, icon: "flame.fill", tag: "°")
    @State var heaterBed = DisplayableInfo(name: "Heater Bed", color: .blue, icon: "bed.double.fill", tag: "°")
    
    var pauseButton: some View {
        DefaultView.Custom.IconTextButton (
            text: "Pause",
            systemName: "pause.circle",
            w: 145,
            h: 55,
            cr: 12
        )
    }
    
    var resumeButton: some View {
        DefaultView.Custom.IconTextButton (
            text: "Resume",
            systemName: "play.circle",
            w: 145,
            h: 55,
            cr: 12
        )
    }
    
    func isPaused (state: PrinterState.State) -> Bool {
        if state == .paused {
            return true
        } else {
            return false
        }
    }
    
    var placeholder: some View {
        Image (systemName: "cube")
            .resizable()
            .foregroundColor(.gray)
    }
    
    // n = Name; ic = icon; v = value; c = color;
    func infoDisplay (n: String, ic: String, v: Int, c: Color, _ tag: String) -> some View {
        ZStack {
            Rectangle()
                .frame(width: 205, height: 25, alignment: .trailing)
                .foregroundColor(c)
                .offset(x: -8)
                .opacity(0.2)
                .blur(radius: 20)
            VStack {
                HStack {
                    Image(systemName: ic)
                    Text(n)
                    Spacer()
                    Text ("\(v)\(tag)")
                        .font(.callout)
                        .padding(.horizontal)
                }
                .frame(width: 205, height: 20, alignment: .trailing)
                Rectangle()
                    .frame(width: 195, height: 2)
                    .foregroundColor(c)
                    .offset(x: -8)
            }
            .padding(.top)
        }
    }
    
    var body: some View {
        
        var displayInfos: [DisplayableInfo] = [progress, extruder, heaterBed]
        
        VStack {
            
            Group {
                let title = TextFormat.beauty(printStats.fileName, .removeParenthesesContent)
                let subTitle = TextFormat.beauty(printStats.fileName, .extractParenthesesContent)
                Text (title.prefix(26))
                    .font(.system(size: 28, weight: .thin))
                Text (subTitle)
                    .font(.system(size: 17, weight: .thin))
                    .foregroundColor(.gray)
            }
            .multilineTextAlignment(.center)
            
            ZStack {
                
                if isPaused(state: state) {
                    Image(systemName: "pause.fill")
                        .resizable()
                        .frame(width: 90, height: 90)
                        .foregroundColor(.orange)
                }
                
                Group {
                    
                    if (printStats.image == UIImage(systemName: "cube")) {
                        placeholder
                    } else {
                        Image(uiImage: printStats.image)
                            .resizable()
                    }
                    
                }
                .frame(width: 180, height: 180)
                .padding(.all)
                .opacity(isPaused(state: state) ? 0.3 : 1.0)
                .blur(radius: isPaused(state: state) ? 10 : 0)
                
            }
            
            ForEach(displayInfos) { info in
                let value = info.values.last ?? 0.0
                infoDisplay(n: info.name, ic: info.icon, v: Int(value), c: info.color, info.tag)
            }
            
            Spacer()
            
            HStack {
                
                Group {
                    if isPaused(state: state) {
                        resumeButton
                    } else {
                        pauseButton
                    }
                }
                .onTapGesture {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    Task {
                        if isPaused(state: state) {
                            try await POST.Print.resume(pr: printerInfo.main)
                        } else {
                            try await POST.Print.pause(pr: printerInfo.main)
                        }
                    }
                }
                
                DefaultView.Custom.IconTextButton (
                    text: "Cancel",
                    systemName: "xmark.circle",
                    w: 145,
                    h: 55,
                    cr: 12
                )
                .onTapGesture {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    Task {
                        try await POST.Print.cancel(pr: printerInfo.main)
                    }
                }
                
            }
            .padding(.top)
            
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
        .animation(.spring(), value: printStats.progress)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { timer in
                Task {
                    let pr = printerInfo.main
                    state = try await pr.state()
                    extruder.values = try await GET.Server.tempStore(pr: pr).extruder.temperatures
                    heaterBed.values = try await GET.Server.tempStore(pr: pr).heaterBed.temperatures
                    printStats = try await GET.Machine.printStats(pr: pr)
                    progress.values.append(Double(Converter.progress(printStats.progress)))
                }
                displayInfos = [progress, extruder, heaterBed]
            }
        }
    }
}
