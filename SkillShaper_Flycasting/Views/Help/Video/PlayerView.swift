//
//  PlayerView.swift
//  SkillShaper_Flycasting
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class PlayerView: UIView {
    
    var playerLayer = AVPlayerLayer()
    
    init(frame: CGRect, player: AVPlayer) {
        
        super.init(frame: frame)
        
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.backgroundColor = UIColor.black.cgColor

        layer.addSublayer(playerLayer)
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        playerLayer.frame = bounds
    }
}
