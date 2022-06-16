//
//  Video.swift
//  SkillShaper_Flycasting
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import SwiftUI
import AVFoundation

struct Video: UIViewRepresentable {
    
    var player: AVPlayer
    
    func makeUIView(context: Context) -> UIView {
        
        return PlayerView(frame: .zero, player: player)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
        (uiView as! PlayerView).playerLayer.player = player
    }
}
