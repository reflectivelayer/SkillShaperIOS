//
//  Main.swift
//  Skillshaper SwiftUI
//
/*
import SwiftUI

struct Main: View {
    
    var body: some View {
        
        TabView {
            
            Dashboard()
                .tabItem {
                    
                    Image(systemName:"gamecontroller")
                    Text("Dashboard")
            }
            
            Help()
                .tabItem {
                    
                    Image(systemName:"doc.plaintext")
                    Text("Help")
            }
        }
        .accentColor(.green)
    }
}

struct Main_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Main()
    }
}
*/

import SwiftUI

struct Main: View {

    let viewModel = DashboardViewModel()
    
    var body: some View {
        HomeView(viewModel:viewModel.configViewModel, motion: MotionManager())
         
    }
}

#if DEBUG
struct Main_Previews: PreviewProvider {
    
    static var previews: some View {
        Main()
    }

}
#endif

extension UIColor {
    convenience init(hexaString: String, alpha: CGFloat = 1) {
        let chars = Array(hexaString.dropFirst())
        self.init(red:   .init(strtoul(String(chars[0...1]),nil,16))/255,
                  green: .init(strtoul(String(chars[2...3]),nil,16))/255,
                  blue:  .init(strtoul(String(chars[4...5]),nil,16))/255,
                  alpha: alpha)}
}
