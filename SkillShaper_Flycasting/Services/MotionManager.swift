//
//  MotionManager.swift
//  SkillShaper_Flycasting
//
//  Created by PUA on 10/9/21.
//  Copyright © 2021 skillshaper.us. All rights reserved.
//

import Foundation
import CoreMotion

class MotionManager: ObservableObject {
    static let accMultiplier = 0.8
    // MotionManager use the ObservableObject Combine property.
    private var motionManager: CMMotionManager
    @Published var acc: CMAcceleration = CMAcceleration()
    
    func start() {
        motionManager.startDeviceMotionUpdates(to: .main) { (accData, error) in
            guard error == nil else {
                print(error!)
                return
            }
            if let data = accData {
                self.acc = data.userAcceleration
            }
            
        }
    }
    
    func stop() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    init() {
        self.motionManager = CMMotionManager()
        self.motionManager.startDeviceMotionUpdates(to: .main) { (accData, error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            if let data = accData {
                self.acc = data.userAcceleration
            }
            
        }
        
    }
}
