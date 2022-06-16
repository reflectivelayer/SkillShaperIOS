//
//  Hear.swift
//  SkillShaper_Flycasting
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import Foundation

enum Hear: Int, SettingsParameter {
    
    case fore
    case back
    
    var name: String {
        
        switch self {
        case .fore: return "fore"
        case .back: return "back"
        }
    }
}
