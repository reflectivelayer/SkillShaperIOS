//
//  StopViewModel.swift
//  SkillShaper_Flycasting
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import Foundation
import AVFoundation

struct StopViewModel {
    
    private let firstPlayer = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "stopstrong", ofType: "mp4")!))
    private let secondPlayer = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "stopweak", ofType: "mp4")!))
    
    var isStrongStop = true
    
    var title: String {
        
        isStrongStop ? "Practice Casting: STOPS" : "Practice Casting: STOPS"
    }
    
    var rules: String {
        
        isStrongStop ? "1. Stop your stroke strong\n2. Hold the rod where it stops\n3. Listen to the sound you made\n4. Practice until you do it without thinking and it sounds right every time" : "1. Stop your stroke strong\n2. Avoid weak stops\n3. Weak stops make softer, duller sounds\n4. Practice until you do it without thinking and it sounds right every time"
    }
    
    var player: AVPlayer {
        
        isStrongStop ? firstPlayer : secondPlayer
    }
    
    var subtitle: String {
        
        isStrongStop ? "Good stop" : "Weak stop"
    }
    
    var buttonTitle: String {
        
        isStrongStop ? "Weak" : "Strong"
    }
}

