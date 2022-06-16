//
//  Config.swift
//  SkillShaper_Flycasting
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import SwiftUI

struct Config: View {
    
    @ObservedObject var viewModel: ConfigViewModel
    
    var body: some View {
        
        VStack {
            
            Text("Watch: \(viewModel.isPlayingTitle)")

            Text("Skill: \(viewModel.skillTitle)")

            if viewModel.watchPositionIsShowed {

                Text("Watch position: \(viewModel.watchPositionTitle)")
            } else {
                
                Text("Hear on: \(viewModel.hearsTitle)")
            }
        }
    }
}

struct Config_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Config(
            viewModel: ConfigViewModel(
                settingsStore: SettingsStore()
            )
        )
    }
}
