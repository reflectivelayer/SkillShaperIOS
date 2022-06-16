//
//  Dashboard.swift
//  SkillShaper_Flycasting
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import SwiftUI

let viewModel = DashboardViewModel()

struct Dashboard: View {
    
    var body: some View {
        
        ZStack {
            
            Logo()
            
            Config(viewModel: viewModel.configViewModel)
        }
        .padding(16)
    }
}

struct Dashboard_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Dashboard()
    }
}

