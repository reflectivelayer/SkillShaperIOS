//
//  UserDefaultsService.swift
//  SkillShaper_Flycasting WatchKit Extension
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import Foundation
import Combine

class UserDefaultsService {
    
    private var cancellables = Set<AnyCancellable>()
    
    init(settingsStore: SettingsStore) {
        
        settingsStore.$skill.sink { skill in
            
            UserDefaults.standard.set(skill.rawValue, forKey: "s")
        }.store(in: &cancellables)
        
        settingsStore.$hears.sink { hears in
            
            UserDefaults.standard.set(hears.map { $0.rawValue }, forKey: "h")
        }.store(in: &cancellables)
        
        settingsStore.$watchPosition.sink { watchPosition in
            
            UserDefaults.standard.set(watchPosition.rawValue, forKey: "w")
        }.store(in: &cancellables)
    }
    
    static func loadSkill() -> Skill {
        
        guard let value = UserDefaults.standard.object(forKey: "s") as? Int,
            let skill = Skill(rawValue: value) else {
                
                return .stroke
        }
        
        return skill
    }
    
    static func loadHears() -> [Hear] {
        
        guard let values = UserDefaults.standard.object(forKey: "h") as? [Int] else {
            
            return [.fore]
        }
        
        var hears = [Hear]()
        
        for value in values {
            
            if let hear = Hear(rawValue: value) {
                
                hears.append(hear)
            } else {
                
                continue
            }
        }
        
        return hears.isEmpty ? [.fore] : hears
    }
    
    static func loadWatchPosition() -> WatchPosition {
        
        guard let value = UserDefaults.standard.object(forKey: "w") as? Int,
            let watchPosition = WatchPosition(rawValue: value) else {
                
                return .wRod
        }
        
        return watchPosition
    }
}
