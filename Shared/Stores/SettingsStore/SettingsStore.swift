//
//  SettingsStore.swift
//  SkillShaper_Flycasting
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import Foundation

class SettingsStore: ObservableObject {
    
    @Published var skill: Skill = .stroke
    @Published var hears: [Hear] = [.fore]
    @Published var watchPosition: WatchPosition = .wRod
    @Published var isPlaying: Bool = false
    
    #if os(watchOS)
    
    init() {
        
        skill = UserDefaultsService.loadSkill()
        hears = UserDefaultsService.loadHears()
        watchPosition = UserDefaultsService.loadWatchPosition()
    }
    
    #endif
}

class PhoneStore{
    var skill: Skill = .stroke
    var hears: [Hear] = []
    var isLeft: Bool = false
    var allMoves: Bool = true
    var strokeFore: Bool = true
    var strokeBack: Bool = false
    var staightLeft: Bool = true
    var straightRight: Bool = true
    var stopFore: Bool = true
    var stopBack: Bool = false
    
    init() {
        var hand = UserDefaults.standard.string(forKey: "hand")
        if(hand == nil){
            hand = "right"
            UserDefaults.standard.set(hand,forKey: "hand")
        }
        if(hand == "left"){
            isLeft = true
        }
        var skillType = UserDefaults.standard.string(forKey: "skill")
        if(skillType == nil){
            skillType = "stroke"
            UserDefaults.standard.set(skillType,forKey: "skill")
            UserDefaults.standard.set("true",forKey: "strokeFore")
            UserDefaults.standard.set("false",forKey: "strokeBack")
            UserDefaults.standard.set("true",forKey: "stopFore")
            UserDefaults.standard.set("false",forKey: "stopBack")
        }
        if(skillType == "allMoves"){
            skill = .allMoves
            hears.append(.fore)
            hears.append(.back)
        }else if(skillType == "stroke"){
            skill = .stroke
            let strokeF = UserDefaults.standard.string(forKey: "strokeFore")
            if(strokeF == "true"){
                hears.append(.fore)
            }
            let strokeB = UserDefaults.standard.string(forKey: "strokeBack")
            if(strokeB == "true"){
                hears.append(.back)
            }
        }else if(skillType == "straight"){
            skill = .straight
        }else if(skillType == "stop"){
            skill = .stop
            let stopF = UserDefaults.standard.string(forKey: "stopFore")
            if(stopF == "true"){
                hears.append(.fore)
            }
            let strokeB = UserDefaults.standard.string(forKey: "stopBack")
            if(strokeB == "true"){
                hears.append(.back)
            }
        }
    }
}
