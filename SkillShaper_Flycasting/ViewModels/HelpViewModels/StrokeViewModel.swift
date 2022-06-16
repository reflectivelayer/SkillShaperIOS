//
//  StrokeViewModel.swift
//  SkillShaper_Flycasting
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import Foundation
import AVFoundation

struct StrokeViewModel {
    
    private let firstPlayer = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "strokefore", ofType: "mp4")!))
    private let secondPlayer = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "strokebothways", ofType: "mp4")!))
    
    var isStrokeOneWay = true
    
    var title: String {
        
        isStrokeOneWay ? "Practice Casting: Stroke 1-way" : "Practice Casting: Stroke 2-way"
    }
    
    var rules: String {
        
        isStrokeOneWay ? "1. Start your stroke slowly\n2. Accelerate smoothly to a strong stop\n3. Listen to the sound you made\n4. Practice until you do it without thinking and it sounds right every time" : "1. Start each stroke slowly\n2. Accelerate smoothly to strong stops\n3. Listen to the sound you made\n4. Practice until you do it without thinking and it sounds right every time"
    }
    
    var player: AVPlayer {
        
        isStrokeOneWay ? firstPlayer : secondPlayer
    }
    
    var subtitle: String {
        
        isStrokeOneWay ? "Stroke - Forward cast" : "Stroke - Both ways"
    }
    
    var buttonTitle: String {
        
        isStrokeOneWay ? "2-Way" : "1-Way"
    }
}
