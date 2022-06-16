//
//  MotionService.swift
//  Skillshaper SwiftUI WatchKit Extension
//

import Foundation
import CoreMotion

class MotionService {
    
    private let settingsStore: SettingsStore
    private let motionManager = CMMotionManager()
    private let maxRodAngleForRollCast = 9.0
    //private var rodAngle = 0.0
    @Published var rodAngle: Double = 0.0
    @Published var sensorValue: Double = 0.0
    
    init(settingsStore: SettingsStore) {
        
        self.settingsStore = settingsStore
        motionManager.deviceMotionUpdateInterval = 0.020 //   New
    }
    
    private func updateSensorValue(for acceleration: CMAcceleration) { //}, for angle: CMAttitude) {
        
        switch settingsStore.skill {
        case .stroke, .stop:
            sensorValue = acceleration.z
        case .straight:
            sensorValue = settingsStore.watchPosition == .sideways ? acceleration.y : acceleration.x
        //case .rollCast:
        //    rodAngle = angle.pitch
        //    if rodAngle > maxRodAngleForRollCast
        //        {sensorValue = 0.0}
                //    else
        //        {sensorValue = acceleration.z}
        default:
            sensorValue = acceleration.z
        }
    }
    
    //private func updateRodAngle(for angle: CMAttitude){
    //    rodAngle = angle.pitch
    //}
    func startUpdating() {
        
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { [weak self] (deviceMotion, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let self = self, let acceleration = deviceMotion?.userAcceleration else { return }
            
            self.updateSensorValue(for: acceleration)
        }
    }
    
    func stopUpdating() {
        
        motionManager.stopDeviceMotionUpdates()
    }
}
