//
//  SectionStrategy.swift
//  SkillShaper_Flycasting
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import Foundation

protocol SectionStrategy {
    
    associatedtype Parameter: SettingsParameter
    
    func checkBoxViewModels() -> [CheckBoxViewModel<Parameter>]
    func update(value: Parameter) -> Bool
}
