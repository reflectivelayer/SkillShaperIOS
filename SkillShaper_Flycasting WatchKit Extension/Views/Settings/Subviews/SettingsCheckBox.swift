//
//  SettingsCheckBox.swift
//  SkillShaper_Flycasting
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import SwiftUI
import Combine

struct SettingsCheckBox<Parameter: SettingsParameter>: View {
    
    @ObservedObject var viewModel: CheckBoxViewModel<Parameter>
    
    var body: some View {
        
        Button(action: {
            
            self.viewModel.checkBoxTapped()
            
        }) {
            
            HStack(spacing: 4) {
                
                Image(viewModel.imageName)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.green)
                    .frame(width: 25, height: 25)
                
                Text(viewModel.title)
                    .bold()
                    .foregroundColor(.green)
                
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingsCheckBox_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            
            SettingsCheckBox(viewModel: CheckBoxViewModel(value: Skill.stroke))
            
            SettingsCheckBox(viewModel: CheckBoxViewModel(value: Skill.stop, isSelected: true))
        }
    }
}
