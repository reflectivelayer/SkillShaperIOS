//
//  WatchPosition.swift
//  SkillShaper_Flycasting
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import Foundation

enum WatchPosition: Int, SettingsParameter {
    
    case wRod
    case sideways
    
    var name: String {
        
        switch self {
        case .wRod: return "w Rod"
        case .sideways: return "sideways"
        }
    }
}
