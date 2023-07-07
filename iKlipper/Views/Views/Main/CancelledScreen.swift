import SwiftUI

struct CancelledScreen: View {
    
    @EnvironmentObject var printerInfo: PrinterInfo
    @Binding var state: PrinterState.State
    
    @State var temp: [String: [Double]] = [
        "extruder": [],
        "heater_bed": [],
    ]
    
    @State var progress = DisplayableInfo(name: "Progress", color: .white, icon: "figure.stand", tag: "%")
    
    @State var printStats: PrintStats = PrintStats (image: UIImage(systemName: "cube")!, filePath: " ", fileSize: 0, fileName: " ", progress: 0, totalDuration: 0, printDuration: 0, filamentUsed: 0)
    
    var placeholder: some View {
        Image (systemName: "cube")
            .resizable()
            .foregroundColor(.gray)
    }
    
    @State var wantToBackHome: Bool = false
    
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
        
        var displayInfos: [DisplayableInfo] = [progress]
        
        VStack {
            
            Text ("CANCELLED")
                .font(.system(size: 35, weight: .heavy))
                .foregroundColor(.red)
            
            Group {
                let title = TextFormat.beauty(printStats.fileName, .removeParenthesesContent)
                Text (title.prefix(26))
                    .font(.system(size: 28, weight: .thin))
                    .foregroundColor(.red)
            }
            .multilineTextAlignment(.center)
            
            ZStack {
                
                Image(systemName: "multiply")
                    .resizable()
                    .frame(width: 110, height: 110)
                    .foregroundColor(.red)
                
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
                .opacity(0.3)
                .blur(radius: 10)
                
            }
            
            ForEach(displayInfos) { info in
                let value = info.values.last ?? 0.0
                infoDisplay(n: info.name, ic: info.icon, v: Int(value), c: info.color, info.tag)
            }
            
            Spacer()
                
                DefaultView.Custom.IconTextButton (
                    text: "Back to Home Screen",
                    systemName: "house",
                    w: 290,
                    h: 55,
                    cr: 12
                )
                .onTapGesture {
                    wantToBackHome.toggle()
                }
                .fullScreenCover(isPresented: $wantToBackHome) {
                    OperationalScreen(state: $state)
                }
            
            Spacer()
            
        }
        .animation(.spring(), value: printStats.progress)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { timer in
                Task {
                    let pr = printerInfo.main
                    state = try await pr.state()
                    printStats = try await GET.Machine.printStats(pr: pr)
                    progress.values.append(Double(Converter.progress(printStats.progress)))
                }
                displayInfos = [progress]
            }
        }
    }
}
