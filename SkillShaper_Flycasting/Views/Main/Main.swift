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
