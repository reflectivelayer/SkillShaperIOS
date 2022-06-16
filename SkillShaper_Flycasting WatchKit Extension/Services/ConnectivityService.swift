//
//  ConnectivityService.swift
//  Skillshaper SwiftUI WatchKit Extension
//

import Foundation
import Combine
import WatchConnectivity

class ConnectivityService: NSObject {
    
    private let store: SettingsStore
    private let session: WCSession = .default
    
    private var isPlayingChanges: AnyCancellable!
    private var sensorChanges: AnyCancellable!
    private var skillChanges: AnyCancellable!
    private var hearsChanges: AnyCancellable!
    private var watchPositionChanges: AnyCancellable!
    
    init(store: SettingsStore, publisher: Published<Double>.Publisher) {
        
        self.store = store
        
        super.init()
        
        self.session.delegate = self
        self.session.activate()
        
        self.subscribeToIsPlayingChanges()
        self.subscribeToSensorChanges(publisher: publisher)
        self.subscribeToSkillChanges()
        self.subscribeToHearsChanges()
        self.subscribeToWatchPositionChanges()
    }
    
    private func subscribeToIsPlayingChanges() {
        
        isPlayingChanges = store.$isPlaying.sink { [weak self] value in
            
            guard let self = self else { return }
            
            self.sendPlayingStatus(value: value)
        }
    }
    
    private func subscribeToSensorChanges(publisher: Published<Double>.Publisher) {
        
        sensorChanges = publisher.sink { [weak self] value in
            
            guard let self = self else { return }
            
            if value > 0.01 || value < -0.01 {
                
                self.sendSensorValue(value: value)
            }
        }
    }
    
    private func subscribeToSkillChanges() {
        
        skillChanges = store.$skill.sink { [weak self] value in
            
            guard let self = self else { return }
            
            self.sendSkill(value: value)
        }
    }
    
    private func subscribeToHearsChanges() {
        
        hearsChanges = store.$hears.sink { [weak self] values in
            
            guard let self = self else { return }
            
            self.sendHears(values: values)
        }
    }
    
    private func subscribeToWatchPositionChanges() {
        
        watchPositionChanges = store.$watchPosition.sink { [weak self] value in
            
            guard let self = self else { return }
            
            self.sendWatchPosition(value: value)
        }
    }
    
    private func sendPlayingStatus(value: Bool) {
        
        let message = ["p": value]
        
        session.sendMessage(message, replyHandler: nil) { error in
            
            print("ERROR watchOS.ConnectivityService.sendPlayingStatus: \(error), \(error.localizedDescription)")
        }
    }
    
    private func sendSensorValue(value: Double) {
        
        let message = ["v": Float32(value)]
        
        session.sendMessage(message, replyHandler: nil) { error in
            
            print("ERROR watchOS.ConnectivityService.sendSensorValue: \(error), \(error.localizedDescription)")
        }
        //NSLog(value.description);
    }
    
    private func sendSkill(value: Skill) {
        
        let message = ["s": value.rawValue]
        
        session.sendMessage(message, replyHandler: nil) { error in
            
            print("ERROR watchOS.ConnectivityService.sendSkill: \(error), \(error.localizedDescription)")
        }
    }
    
    private func sendHears(values: [Hear]) {
        
        let message = ["h": values.map { $0.rawValue }]
        
        session.sendMessage(message, replyHandler: nil) { error in
            
            print("ERROR watchOS.ConnectivityService.sendHears: \(error), \(error.localizedDescription)")
        }
    }
    
    private func sendWatchPosition(value: WatchPosition) {
        
        let message = ["w": value.rawValue]
        
        session.sendMessage(message, replyHandler: nil) { error in
            
            print("ERROR watchOS.ConnectivityService.sendWatchPosition: \(error), \(error.localizedDescription)")
        }
    }
}

extension ConnectivityService: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        if let error = error {
            
            print("ERROR watchOS.ConnectivityService.activationDidCompleteWith: \(error), \(error.localizedDescription)")
        }
        
        print("watchOS.ConnectivityService.activationDidCompleteWith activationState: \(activationState.rawValue)")
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        
        if session.isReachable {
            
            sendSkill(value: store.skill)
            sendHears(values: store.hears)
            sendWatchPosition(value: store.watchPosition)
        }
    }
}
