//
//  AudioService.swift
//  Skillshaper SwiftUI
//
//  Copyright © langbourne rust research inc. All rights reserved.
//

import Foundation
import Combine
import AVFoundation
import CoreMotion

class AudioService {
    
    private let settingsStore: SettingsStore
    
    private var engine = AVAudioEngine()
    private var audioPlayer = AVAudioPlayerNode()
    private var pitchControl = AVAudioUnitTimePitch()
    //
    private var speedControl = AVAudioUnitVarispeed() //            NEW FOR SPEED CONTROL
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    private var uAccel = 0.0
    private var lastReading = 0.0
    private var uPeak = 0.0
    private var bStopHasStarted = false
    private var gain = 0.0
    private var isLogging = false
    var motionCanceller: AnyCancellable?
    
    init(settingsStore: SettingsStore, publisher: Published<CMAcceleration>.Publisher) {
        self.settingsStore = settingsStore
        configurate(for: .stroke)
        if(motionCanceller == nil ){
            motionCanceller = publisher.sink { [weak self] acc in
                if !remoteAccelerometer { return }
                guard let self = self else { return }
                if(!self.isLogging){return}
                let sensorValue = acc.x
                guard self.validateSensorValue(value: sensorValue) else {
                    //                           ---------------------------------------Not validated ----------
                    self.audioPlayer.volume = 0.0
                    self.pitchControl.pitch = 0.0
                    self.uPeak = 0.0
                    self.bStopHasStarted = false
                    self.lastReading = sensorValue
                    return }
                //                           ------------------------------------------ Validated ----------
                if settingsStore.skill == .stop {
                    self.uAccel = abs(sensorValue*5)
                    self.gain = sensorValue - self.lastReading
                    print(self.gain)
                    if sensorValue < 0.0 {
                        self.gain = self.gain * -1
                    }
                    if self.bStopHasStarted { //               If Stopping has already started
                       //self.path += "a1 "
                       if self.uAccel > self.uPeak { //           if accel is greater than peak
                           self.uPeak = self.uAccel //                 reset peak
                           self.updateVolume(with: self.uAccel)
                           self.updatePitch(with: self.uAccel)
                       }
                       else { //                                  if accel is less than peak
                           if self.uAccel < 0.2{ //                   if accel less than 0.2
                               self.bStopHasStarted = false//               turn off Stopping Flag
                               self.uPeak = 0.0 //                          Algo 8c
                               self.updateVolume(with: 0.0) //              turn off sound
                               self.updatePitch(with: 0.0)
                            
                           }
                           else { //                                   but if accel is still higher than 0.2
                               self.updateVolume(with: self.uAccel) //       update volume ... but not pitch
                               self.updatePitch(with: self.uPeak) //         no change in peak
                           }
                       }
                   }
                   else { //                                  Stopping has NOT sterted
                       if self.uAccel > 1.6 && self.gain > 0.2{ //   If sharp change to strong accel
                           self.bStopHasStarted = true //                  set StoppingFlag to true
                           self.uPeak = self.uAccel //                     set peak
                           self.updateVolume(with: self.uAccel)
                           self.updatePitch(with: self.uAccel) //        update pitch & volume
                           }
                       else { //                                         If accel not signalling a Stopping event
                           self.uPeak = 0.0 //                     Algo 8c
                           self.updateVolume(with: 0.0)
                           self.updatePitch(with: 0.0)
                       }
                  }
                }
                else {
                    self.updateVolume(with: sensorValue)
                    self.updatePitch(with: sensorValue)
                }
                self.lastReading = sensorValue
                self.updateTimer()
            }
        }
    }
    
    func configurate(for skill: Skill, hears: [Hear] = [Hear]()) {
        settingsStore.skill = skill
        settingsStore.hears = hears
        if audioPlayer.isPlaying {
            audioPlayer.stop()
        }
        if engine.isRunning {
            engine.stop()
            engine.reset()
        }
        engine = AVAudioEngine()
        audioPlayer = AVAudioPlayerNode()
        pitchControl = AVAudioUnitTimePitch()
        let fileName = skill == .straight ? "c4sq" : "g5sq" // ORIGINAL
        let filePath = Bundle.main.path(forResource: fileName, ofType: "wav")!
        let filePathURL = URL(fileURLWithPath: filePath)

        let audioFile = try! AVAudioFile(forReading: filePathURL)
        let audioPCMFormat = audioFile.processingFormat
        let audioFrameCount = AVAudioFrameCount(audioFile.length)
        let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioPCMFormat, frameCapacity: audioFrameCount)!

        try! audioFile.read(into: audioBuffer)
        engine.attach(audioPlayer)
        engine.attach(pitchControl)
        engine.attach(speedControl)
        if skill == .straight {
            engine.connect(audioPlayer, to: pitchControl, format: nil)
            engine.connect(pitchControl, to: engine.mainMixerNode, format:nil)
        } else {
            engine.connect(audioPlayer, to: speedControl, format:nil) //        New - for speedControl
            engine.connect(speedControl, to: pitchControl, format: nil) //  New - for speedControl
            engine.connect(pitchControl, to: engine.mainMixerNode, format: nil) // Original
        }
        audioPlayer.scheduleBuffer(audioBuffer, at: nil, options: .loops)
        try! engine.start()
        
        audioPlayer.volume = 0.0
        pitchControl.pitch = 0.0
        if skill == .stop {  //
            speedControl.rate = 1.0}
        else {
            speedControl.rate = 0.4}
        audioPlayer.play()
    }
    
    private func validateSensorValue(value: Double) -> Bool {
        let skill = settingsStore.skill
        let hears = settingsStore.hears
        switch skill {
        case .stroke:
            if (value <= 0 && hears.contains(.back)) || (value > 0 && hears.contains(.fore)) {
                return true
            }
            return false
            
        case .stop:
            if (value < 0 && hears.contains(.fore)) || (value >= 0 && hears.contains(.back)) {
                return true
            }
            return false
            
        default:
            return true
        }
    }
    
    private func updateTimer() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.3,repeats: false) { [weak self] _ in
                guard let self = self else { return }
                
                self.audioPlayer.volume = 0.0
                self.pitchControl.pitch = 0.0
            }
        }
        if self.settingsStore.skill == .stop { //       New .. puts Stop feedback into higher register
            self.speedControl.rate = 1.0}
        else{
            self.speedControl.rate = 0.4
        }
        audioPlayer.play()
    }
    
    private func updatePitch(with sensorValue: Double) {
        var sensitivityFactor = 1500.0
                var rawPitch = 0.0
                if settingsStore.skill == .stop{  //                    for STOP, sensorValue argument is already abs( )
                    sensitivityFactor = 330.0
                    rawPitch = pow(sensorValue,0.5) * sensitivityFactor
                    //rawPitch = sensorValue * sensitivityFactor
                }
                else{
                    let uSensorValue = abs(sensorValue)
                    rawPitch = pow(uSensorValue,0.5) * sensitivityFactor
                }
                let pitch = rawPitch > 2400.0 ? 2400.0 : rawPitch
                self.pitchControl.pitch = Float(pitch)
      
    }

    private func updateVolume(with sensorValue: Double) {
        let uSensorValue = abs(sensorValue)
        if settingsStore.skill == .straight && uSensorValue < 0.12{
            self.audioPlayer.volume = 0.0;
            return
        }
        let rawVolume = Float(uSensorValue)//                   Edit 3 Sept 9 // use this when not Bench testing
        let volume = rawVolume > 1.0 ? 1.0 : rawVolume
        self.audioPlayer.volume = volume
    }
    
    func play() {
        
//        pitchControl.pitch = 0.0
//        audioPlayer.volume = 0.0
//
//        audioPlayer.play()
        isLogging = true
    }
    
    func stop() {
        isLogging = false
//        audioPlayer.pause()
    }
}

