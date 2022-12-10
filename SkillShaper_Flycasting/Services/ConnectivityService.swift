//
//  ConnectivityService.swift
//  Skillshaper SwiftUI
//

import Foundation
import Combine
import WatchConnectivity
import CoreMotion

class ConnectivityService: NSObject {
    
    private let settingsStore: SettingsStore
    private let session: WCSession = .default
    @Published var sensorValueXYZ:CMAcceleration = CMAcceleration()
    
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
        if(message.keys.contains("t")){
            let axisX = Double(message["v"] as! Float32)
            let axisY = Double(message["u"] as! Float32)
            let axitZ = Double(message["t"] as! Float32)
            sensorValueXYZ = CMAcceleration(x:axisX,y:axisY,z:axitZ)
            //print(message)
            //print(NSDate.timeIntervalSinceReferenceDate)
        }else{
            switch key {
                case "p":
                    settingsStore.isPlaying = message[key] as! Bool
                    if(settingsStore.isPlaying){
                        strokeManager.start()
                    }else{
                        strokeManager.stop()
                        strokeManager.saveData()
                    }
                case "s": settingsStore.skill = Skill(rawValue: message[key] as! Int)!
                case "h": settingsStore.hears = (message[key] as! [Int]).map { Hear(rawValue: $0)! }
                case "w": settingsStore.watchPosition = WatchPosition(rawValue: message[key] as! Int)!
                default:
                    break
            }
        }
    }
}
