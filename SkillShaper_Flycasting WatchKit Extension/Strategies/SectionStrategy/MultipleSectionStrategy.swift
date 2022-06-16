//
//  MultipleSectionStrategy.swift
//  SkillShaper_Flycasting
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import Foundation

class MultipleSectionStrategy<Parameter: SettingsParameter>: SectionStrategy {
    
    private let keyPath: WritableKeyPath<SettingsStore, [Parameter]>
    
    private var store: SettingsStore
    
    required init(store: SettingsStore, keyPath: WritableKeyPath<SettingsStore, [Parameter]>) {
        
        self.store = store
        self.keyPath = keyPath
    }
    
    func checkBoxViewModels() -> [CheckBoxViewModel<Parameter>] {
        
        var viewModels = [CheckBoxViewModel<Parameter>]()
        
        for item in Parameter.allCases {
            
            let isSelected = store[keyPath: keyPath].contains(item)
            let viewModel = CheckBoxViewModel(value: item, isSelected: isSelected)
            
            viewModels.append(viewModel)
        }
        
        return viewModels
    }
    
    func update(value: Parameter) -> Bool {
        
        let selectedCount = store[keyPath: keyPath].count
        let isSelected = store[keyPath: keyPath].contains(value)
        
        if selectedCount < 2 && isSelected { return false }
        
        if isSelected {
            
            let parameterIndex = store[keyPath: keyPath].firstIndex { $0 == value }!
            store[keyPath: keyPath].remove(at: parameterIndex)
            
            return true
        }
        
        store[keyPath: keyPath].append(value)
        
        return true
    }
}
