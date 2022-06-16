//
//  SettingsSection.swift
//  SkillShaper_Flycasting
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import SwiftUI
import Combine

struct SettingsSection<Strategy: SectionStrategy>: View {
    
    let viewModel: SectionViewModel<Strategy>
    
    var body: some View {
        
        VStack(spacing: 8) {
            
            HStack {
                
                Text(viewModel.title)
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(.green)
                
                Spacer()
            }
            
            ForEach(viewModel.checkBoxViewModels, id: \.id) { checkBoxViewModel in
                
                SettingsCheckBox(viewModel: checkBoxViewModel)
                    .padding(.leading)
            }
        }
    }
}

struct SettingsSection_Previews: PreviewProvider {
    
    static var previews: some View {
        
        SettingsSection<SingleSectionStrategy>(viewModel: SectionViewModel(store: SettingsStore(), keyPath: \.skill))
    }
}
