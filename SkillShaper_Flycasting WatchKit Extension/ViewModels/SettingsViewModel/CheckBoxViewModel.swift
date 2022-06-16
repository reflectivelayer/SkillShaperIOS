//
//  CheckBoxViewModel.swift
//  SkillShaper_Flycasting
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import Foundation
import Combine

class CheckBoxViewModel<Parameter: SettingsParameter>: ObservableObject, Identifiable {
    
    let publisher = PassthroughSubject<Parameter, Never>()
    let value: Parameter
    let title: String
    
    @Published var isSelected: Bool
    
    var imageName: String {
        
        isSelected ? "checkBoxOn" : "checkBoxOff"
    }

    init(value: Parameter, isSelected: Bool = false) {
        
        self.value = value
        self.title = value.name
        self.isSelected = isSelected
    }
    
    func checkBoxTapped() {
        
        publisher.send(value)
    }
}
