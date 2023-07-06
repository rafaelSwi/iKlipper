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
    
    var placeholder: some View {
        Image (systemName: "cube.transparent")
            .resizable()
            .frame(width: 200, height: 200)
            .padding(.all)
    }
    
    enum ParenthesesContentMethod {
        case removeParenthesesContent
        case extractParenthesesContent
    }
    
    func parenthesesContent(_ input: String, _ method: ParenthesesContentMethod) -> String {
        
        let regex = try! NSRegularExpression(pattern: "\\(([^()]+)\\)")
        
        switch method {
        case .removeParenthesesContent:
            var output = regex.stringByReplacingMatches(
                in: input,
                options: [],
                range: NSRange(location: 0, length: input.utf16.count),
                withTemplate: ""
            )
            output = output.trimmingCharacters(in: .whitespaces)
            return output
        case .extractParenthesesContent:
            let matches = regex.matches(
                in: input,
                options: [],
                range: NSRange(location: 0, length: input.utf16.count)
            )
            
            let extractedContent = matches.map { match in
                let range = match.range(at: 1)
                return (input as NSString).substring(with: range)
            }
            
            return extractedContent.joined(separator: "")
        }
    }
    
    func beauty (_ string: String, _ method: ParenthesesContentMethod) -> String {
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
        switch method {
        case .removeParenthesesContent:
            let result = parenthesesContent(str, .removeParenthesesContent)
            return result.capitalized
        case .extractParenthesesContent:
            let result = parenthesesContent(str, .extractParenthesesContent)
            return result.capitalized
        }
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
                Text (beauty(printStats.fileName, .removeParenthesesContent).prefix(26))
                    .font(.system(size: 28, weight: .thin))
                Text (beauty(printStats.fileName, .extractParenthesesContent))
                    .font(.system(size: 17, weight: .thin))
                    .foregroundColor(.gray)
            }
            .multilineTextAlignment(.center)
            
            if (printStats.image == UIImage(systemName: "cube")) {
                placeholder
            } else {
                Image(uiImage: printStats.image)
                    .resizable()
                    .frame(width: 180, height: 180)
                    .padding(.all)
            }
            
            ForEach(displayInfos) { info in
                let value = info.values.last ?? 0.0
                infoDisplay(n: info.name, ic: info.icon, v: Int(value), c: info.color, info.tag)
            }
            
            Spacer()
            
            HStack {
                
                DefaultView.Custom.IconTextButton (
                    text: "Pause",
                    systemName: "pause.circle",
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
                    systemName: "xmark.circle",
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
