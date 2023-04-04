//
//  ToneGenerator.swift
//  SkillShaper_Flycasting
//
//  Created by DexFX on 4/4/23.
//  Copyright © 2023 skillshaper.us. All rights reserved.
//

import Foundation
import CoreAudioKit

class ToneGenerator {
    var engine: AVAudioEngine!
    var tone: AVTonePlayerUnit!
    
    init() {
        tone = AVTonePlayerUnit()
        let format = AVAudioFormat(standardFormatWithSampleRate:tone.sampleRate, channels: 1)
        print(format?.sampleRate ?? "format nil")
        engine = AVAudioEngine()
        engine.attach(tone)
        let mixer = engine.mainMixerNode
        engine.connect(tone, to: mixer, format: format)
        do {
            try engine.start()
        } catch let error as NSError {
            print(error)
        }
        
        tone.preparePlaying()
        tone.play()
        engine.mainMixerNode.volume = 1.0
    }
}
