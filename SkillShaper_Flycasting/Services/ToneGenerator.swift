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
    var tone: AVTonePlayerUnit! = AVTonePlayerUnit()
    
    public var frequency:Double{
        get{return tone.frequency}
        set{tone.frequency = newValue*1000}
    }
    
    public var volume:Float{
        get{return tone.volume}
        set{tone.volume = newValue}
    }
    
    init() {
        let format = AVAudioFormat(standardFormatWithSampleRate:tone.sampleRate, channels: 1)
        print(format?.sampleRate ?? "format nil")
        engine = AVAudioEngine()
        let mixer = engine.mainMixerNode
        engine.attach(tone)
        
        engine.connect(tone, to: mixer, format: format)
        do {
            try engine.start()
        } catch let error as NSError {
            print(error)
        }
        
        tone.preparePlaying()
        tone.volume = 0
        tone.play()
        engine.mainMixerNode.volume = 1.0
    }
    
    
}
