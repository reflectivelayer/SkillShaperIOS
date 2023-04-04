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
import AudioKit
import AudioKitEX
import SoundpipeAudioKit


class AudioService2 {
    
    private let settingsStore: PhoneStore
    
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
    private var inMax:Double = 0;
    private var inMin:Double = 0;
    var isRemote = false
    var remoteSettingsStore:SettingsStore?
    var motionCanceller: AnyCancellable?
    var toneGenerator:ToneGenerator = ToneGenerator()
    
    init(publisher: Published<CMAcceleration>.Publisher) {
        settingsStore = PhoneStore()
        configurate(for: getSkill(),hears: settingsStore.hears)
        if(motionCanceller == nil){
            motionCanceller = publisher.sink { [weak self] acc in
                //if remoteAccelerometer { return }
                guard let self = self else { return }
                if(!self.isLogging){return}
                var sensorValue = 0.0;
                if self.getSkill() == .allMoves{
                    sensorValue = self.vectoredValue(acc: acc)
                }else if self.getSkill() == .straight{
                    sensorValue = acc.z * MotionManager.accMultiplier
                }else{
                    sensorValue = acc.x * MotionManager.accMultiplier
                }
                guard self.validateSensorValue(value: sensorValue) else {
                    //                           ---------------------------------------Not validated ----------
                    self.updateVolume(with: 0)
                    self.uPeak = 0.0
                    self.bStopHasStarted = false
                    self.lastReading = sensorValue
                    return }
 
                //                           ------------------------------------------ Validated ----------
                if self.getSkill() == .stop {
                    self.uAccel = abs(sensorValue*5)
                    self.gain = sensorValue - self.lastReading
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
            }
        }
    }
    
    func vectoredValue(acc:CMAcceleration)->Double{
        let vXsq = acc.x * acc.x
        let vYsq = acc.y * acc.y
        let vZsq = acc.z * acc.z
        return sqrt(vXsq + vYsq + vZsq)
    }
    
    func configurate(for skill: Skill, hears: [Hear] = [Hear]()) {
        if(oscillator == nil){
            oscillator = Synth()
        }
        
        if !isRemote{
            settingsStore.skill = skill
            settingsStore.hears = hears
        }
    }
    
    private func getSkill() -> Skill{
        if isRemote {
            return remoteSettingsStore!.skill
        }else{
            return settingsStore.skill
        }
    }
    
    private func getHears() -> [Hear]{
        if isRemote {
            return remoteSettingsStore!.hears
        }else{
            return settingsStore.hears
        }
    }
    
    private func validateSensorValue(value: Double) -> Bool {
        let skill = getSkill()
        let hears = getHears()
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
    
    private func updatePitch(with sensorValue: Double) {
        var sensitivityFactor = 1.0//1500.0
        var rawPitch = 0.0
        if getSkill() == .stop{  //                    for STOP, sensorValue argument is already abs( )
            sensitivityFactor = 0.3//330.0
            rawPitch = pow(sensorValue,0.5) * sensitivityFactor
            speedNode.rate = Float(rawPitch * 0.5)
        }else if getSkill() == .stroke{
            let uSensorValue = abs(sensorValue)
            sensitivityFactor = 1.0
            rawPitch = pow(uSensorValue,0.5) * sensitivityFactor
            speedNode.rate = Float(0.5 + sensorValue * 0.25)
        }else if getSkill() == .allMoves{
            let uSensorValue = abs(sensorValue)
            sensitivityFactor = 1.0
            speedNode.rate = Float(0.5 + sensorValue * 0.25)
        }else if getSkill() == .straight{
            let uSensorValue = abs(sensorValue)
            sensitivityFactor = 1.0
            speedNode.rate = Float(0.5 + uSensorValue * 0.5)
        }
        else{
            let uSensorValue = abs(sensorValue)
            sensitivityFactor = 1.0
            rawPitch = pow(uSensorValue,0.5) * sensitivityFactor
            speedNode.rate = Float(0.5 + sensorValue * 2)
        }
        //let pitch = rawPitch > 2400.0 ? 2400.0 : rawPitch

        
        //////////// Test code below
        var change = false
        if sensorValue > inMax{
            inMax = sensorValue
            change = true
        }
        if sensorValue < inMin{
            inMin = sensorValue
            change = true
        }
        if change {
            //print(String(inMax) + ":" + String(inMin))
        }
        
    }

    private func updateVolume(with sensorValue: Double) {
        //print(String(sensorValue))
        let uSensorValue = abs(sensorValue)
        //printMinMax(sensorValue: sensorValue)
        if getSkill() == .straight{
            if uSensorValue < 0.1{
                oscillator?.mainMixer.outputVolume = 0.0;
                return
            }else if (sensorValue < 0 && !getHears().contains(.fore)){
                oscillator?.mainMixer.outputVolume = 0.0;
                return
            }else if (sensorValue > 0 && !getHears().contains(.back)){
                oscillator?.mainMixer.outputVolume = 0.0;
                return
            }else{
            let rawVolume = Float(uSensorValue)//                   Edit 3 Sept 9 // use this when not Bench testing
            let volume = rawVolume > 1.0 ? 1.0 : rawVolume
            oscillator?.mainMixer.outputVolume = volume * 2
            return
            }
        }else if getSkill() == .stroke{
            if uSensorValue < 0.1{
                oscillator?.mainMixer.outputVolume = 0.0;
                return
            }
        }else if getSkill() == .allMoves{
            if uSensorValue < 0.2{
                oscillator?.mainMixer.outputVolume = 0.0;
                return
            }
        }
        let rawVolume = Float(uSensorValue)//                   Edit 3 Sept 9 // use this when not Bench testing
        let volume = rawVolume > 1.0 ? 1.0 : rawVolume
        oscillator?.mainMixer.outputVolume = volume * 2
    }
    
    func printMinMax(sensorValue:Double){
        if sensorValue > inMax{
            inMax = sensorValue
        }
        print(String(inMax) + " : " + String(sensorValue))
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
        oscillator?.mainMixer.outputVolume = 0.0
    }
}


typealias Signal = (Float) -> (Float)
var speedNode = AVAudioUnitVarispeed()
var oscillator:Synth?

class Synth {
    public static let shared = Synth()
    
    public var volume: Float {
        set {
            audioEngine.mainMixerNode.outputVolume = newValue
        }
        get {
            return audioEngine.mainMixerNode.outputVolume
        }
    }
    private var audioEngine: AVAudioEngine
    private let sampleRate: Double
    private let deltaTime: Float
    private var signal: Signal
    private var totalTime:Float = 0
    private var waveVal:Float = 0
    let mainMixer:AVAudioMixerNode
    
    private lazy var sourceNode = AVAudioSourceNode { (_, _, frameCount, audioBufferList) -> OSStatus in
        let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
        for frame in 0..<Int(frameCount) {
            self.waveVal = self.signal(self.totalTime)

            self.totalTime += self.deltaTime
            for buffer in ablPointer {
                let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                buf[frame] = self.waveVal
            }
        }
        return noErr
    }
    
    init(signal: @escaping Signal = Oscillator.sine) {
        self.signal = signal
        audioEngine = AVAudioEngine()
        
        let outputNode = audioEngine.outputNode
        
        //let speedNode = AVAudioUnitTimePitch()
        let format = outputNode.inputFormat(forBus: 0)
        
        speedNode.rate = 2
        sampleRate = format.sampleRate
        deltaTime = 1 / Float(sampleRate)
        mainMixer = audioEngine.mainMixerNode
        let inputFormat = AVAudioFormat(commonFormat: format.commonFormat, sampleRate: sampleRate, channels: 1, interleaved: format.isInterleaved)
        audioEngine.attach(sourceNode)
        audioEngine.attach(speedNode)
        audioEngine.connect(sourceNode, to: speedNode, format: inputFormat)
        audioEngine.connect(speedNode, to: mainMixer, format: inputFormat)
        audioEngine.connect(mainMixer, to: outputNode, format: nil)
        mainMixer.outputVolume = 0
        do {
           try audioEngine.start()
        } catch {
           print("Could not start engine: \(error.localizedDescription)")
        }
    }
    
    public func setWaveformTo(_ signal: @escaping Signal) {
        self.signal = signal
    }
}

struct Oscillator {
    static var amplitude: Float = 1
    static var frequency: Float = 1440
    static var phase: Double = 0
    
    static let sine = { (time: Float) -> Float in
        let period = 1.0 / Double(Oscillator.frequency)
        let currentTime = fmod(Double(time), period)
        phase = currentTime/period
       // print(phase)
        return amplitude * sin(2.0 * Float.pi * frequency * time)
    }
    
    static let square = { (time: Float) -> Float in
        let period = 1.0 / Double(Oscillator.frequency)
        let currentTime = fmod(Double(time), period)
        return ((currentTime / period) < 0.5) ? Oscillator.amplitude : -1.0 * Oscillator.amplitude
    }
}
