import SwiftUI

struct Logo: View {
    
    var body: some View {
        
        VStack {
        
            Image("logo")
            Text("patent pending")
        }
    }
}

struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        Logo()
    }
}

extension Color {
    
    public static var myBackground: Color {
        #if os(iOS)
        return Color(.systemBackground)
        #elseif os(tvOS)
        return Color(.darkGray)
        #elseif os(macOS)
        return Color(.windowBackgroundColor)
        #endif
    }
}
