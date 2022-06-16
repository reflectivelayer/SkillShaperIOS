//
//  SingleSectionStrategy.swift
//  SkillShaper_Flycasting
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import Foundation

class SingleSectionStrategy<Parameter: SettingsParameter>: SectionStrategy {
    
    private let keyPath: WritableKeyPath<SettingsStore, Parameter>
    
    private var store: SettingsStore
    
    required init(store: SettingsStore, keyPath: WritableKeyPath<SettingsStore, Parameter>) {
        
        self.store = store
        self.keyPath = keyPath
    }
    
    func checkBoxViewModels() -> [CheckBoxViewModel<Parameter>] {
        
        var viewModels = [CheckBoxViewModel<Parameter>]()
        
        for item in Parameter.allCases {
            
            let isSelected = item == store[keyPath: keyPath]
            let viewModel = CheckBoxViewModel(value: item, isSelected: isSelected)
            
            viewModels.append(viewModel)
        }
        
        return viewModels
    }
    
    func update(value: Parameter) -> Bool {
        
        guard value != store[keyPath: keyPath] else { return false }
        
        store[keyPath: keyPath] = value
        
        return true
    }
}
