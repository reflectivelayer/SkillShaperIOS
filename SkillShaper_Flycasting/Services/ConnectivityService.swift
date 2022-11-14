//
//  ConnectivityService.swift
//  Skillshaper SwiftUI
//

import Foundation
import Combine
import WatchConnectivity

class ConnectivityService: NSObject {
    
    private let settingsStore: SettingsStore
    private let session: WCSession = .default
    
    @Published var sensorValue: Double = 0.0
    @Published var sensorValueLateral: Double = 0.0
    @Published var sensorValueVertical: Double = 0.0
    
    init(settingsStore: SettingsStore) {
        
        self.settingsStore = settingsStore
        
        super.init()
        
        session.delegate = self
        session.activate()
    }
}

extension ConnectivityService: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        if let error = error {
            print("ERROR iOS.ConnectivityService.activationDidCompleteWith: \(error), \(error.localizedDescription)")
        }
        
        print("iOS.ConnectivityService.activationDidCompleteWith: \(activationState.rawValue)")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
        print("iOS.ConnectivityService.sessionDidBecomeInactive: \(session.activationState.rawValue)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
        print("iOS.ConnectivityService.sessionDidDeactivate: \(session.activationState.rawValue)")
        session.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        guard let key = message.keys.first else { return }
        switch key {
        case "p":
            settingsStore.isPlaying = message[key] as! Bool
            if(settingsStore.isPlaying){
                strokeManager.start()
            }else{
                strokeManager.stop()
            }
        case "t": sensorValueLateral = Double(message[key] as! Float32)
        case "u": sensorValueVertical = Double(message[key] as! Float32)
        case "v": sensorValue = Double(message[key] as! Float32)
        case "s": settingsStore.skill = Skill(rawValue: message[key] as! Int)!
        case "h": settingsStore.hears = (message[key] as! [Int]).map { Hear(rawValue: $0)! }
        case "w": settingsStore.watchPosition = WatchPosition(rawValue: message[key] as! Int)!
        default:
            break
        }
        print(sensorValueVertical)
        //NSLog(message.description)//                                    for Debug Build 25
    }
}
