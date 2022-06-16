//
//  SectionViewModel.swift
//  SkillShaper_Flycasting
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import Foundation
import Combine

class SectionViewModel<Strategy: SectionStrategy> {
    
    typealias Parameter = Strategy.Parameter
    
    private let strategy: Strategy
    
    private var subscribers: [AnyCancellable] = []
    
    private(set) var title: String = ""
    private(set) var checkBoxViewModels = [CheckBoxViewModel<Parameter>]()
    
    init(store: SettingsStore, keyPath: WritableKeyPath<SettingsStore, Parameter>) {
        
        self.strategy = SingleSectionStrategy(store: store, keyPath: keyPath) as! Strategy
        self.setupViewModel(keyPath: keyPath)
    }
    
    init(store: SettingsStore, keyPath: WritableKeyPath<SettingsStore, [Parameter]>) {
        
        self.strategy = MultipleSectionStrategy(store: store, keyPath: keyPath) as! Strategy
        self.setupViewModel(keyPath: keyPath)
    }
    
    private func setupViewModel<Parameter>(keyPath: KeyPath<SettingsStore, Parameter>) {
        
        self.title = sectionTitle(keyPath: keyPath)
        self.checkBoxViewModels = strategy.checkBoxViewModels()
        
        for viewModel in checkBoxViewModels {
            
            let subscriber = viewModel.publisher.sink { [weak self] value in
                
                guard let self = self, self.strategy.update(value: value) else { return }
                
                self.updateCheckBoxViewModels(value: value)
            }
            
            self.subscribers.append(subscriber)
        }
    }
    
    private func updateCheckBoxViewModels(value: Parameter) {
        
        if strategy is SingleSectionStrategy<Parameter> {
            
            for viewModel in checkBoxViewModels {
                
                let isSelected = viewModel.value == value
                
                viewModel.isSelected = isSelected
            }
            
            return
        }
        
        checkBoxViewModels.first(where: { $0.value == value })?.isSelected.toggle()
    }
    
    private func sectionTitle<Parameter>(keyPath: KeyPath<SettingsStore, Parameter>) -> String {
        
        switch keyPath {
        case \SettingsStore.skill: return "Skill"
        case \SettingsStore.hears: return "Hear on..."
        case \SettingsStore.watchPosition: return "Watch position"
        default:
            return ""
        }
    }
}
