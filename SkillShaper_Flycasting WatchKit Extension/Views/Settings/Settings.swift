//
//  Settings.swift
//  SkillShaper_Flycasting
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import SwiftUI

struct Settings: View {
    
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                
                HStack {
                    
                    Text("Settings")
                    .font(.system(.title))
                    .bold()
                    .foregroundColor(.green)
                    
                    Spacer()
                }
                
                SettingsSection<SingleSectionStrategy>(viewModel:
                    SectionViewModel(
                        store: viewModel.settingsStore,
                        keyPath: \.skill
                    )
                )
                
                if viewModel.watchPositionIsShowed {
                    
                    SettingsSection<SingleSectionStrategy>(viewModel:
                        SectionViewModel(
                            store: viewModel.settingsStore,
                            keyPath: \.watchPosition
                        )
                    )
                } else {
                    
                    SettingsSection<MultipleSectionStrategy>(viewModel:
                        SectionViewModel(
                            store: viewModel.settingsStore,
                            keyPath: \.hears
                        )
                    )
                }
                
                Button(action: {
                    
                    self.viewModel.resetSettings()
                    
                }) {
                    
                    Text("Reset")
                        .foregroundColor(.white)
                        .bold()
                        .padding([.top, .bottom], 10)
                        .padding([.leading, .trailing], 20)
                }
                .background(Color.gray)
                .cornerRadius(10)
                .frame(height: 44)
            }
        }
    }
}

struct Settings_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Settings(
            viewModel: SettingsViewModel(
                settingsStore: SettingsStore()
            )
        )
    }
}
