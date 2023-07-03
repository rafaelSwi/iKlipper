import SwiftUI

struct OfflinePrinter: View {
    var body: some View {
        Image(systemName: "wifi.exclamationmark.circle")
        Text("No Connection")
            .font(.system(size: 33).bold())
    }
}
