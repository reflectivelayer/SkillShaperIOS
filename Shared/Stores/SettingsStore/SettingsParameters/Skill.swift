//
//  Skill.swift
//  SkillShaper_Flycasting
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import Foundation

enum Skill: Int, SettingsParameter {
    
    case allMoves
    case stroke
    case stop
    case straight
    
    var name: String {
        
        switch self {
        case .allMoves: return "allMoves"
        case .stroke: return "stroke"
        case .stop: return "stop"
        case .straight: return "straight"
        }
    }
}
