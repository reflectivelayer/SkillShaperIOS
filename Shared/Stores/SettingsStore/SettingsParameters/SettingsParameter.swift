//
//  SettingsParameter.swift
//  SkillShaper_Flycasting
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import Foundation

protocol SettingsParameter: CaseIterable, Equatable {
    
    var name: String { get }
}
