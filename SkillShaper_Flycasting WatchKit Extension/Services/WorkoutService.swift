//
//  WorkoutService.swift
//  Skillshaper SwiftUI WatchKit Extension
//

import Foundation
import HealthKit

class WorkoutService {
    
    private let healthStore = HKHealthStore()
    private let sessionConfig = HKWorkoutConfiguration()
    private var session: HKWorkoutSession?
    
    init() {
        
        sessionConfig.activityType = .other
        sessionConfig.locationType = .unknown
    }
    
    func startSession() {
        
        do {
            
            session = try HKWorkoutSession(healthStore: healthStore, configuration: sessionConfig)
            session?.startActivity(with: nil)
        } catch {
            
            print("watchOS.HKWorkoutSession.ERROR: \(error.localizedDescription)")
        }
    }
    
    func stopSession() {
        
        guard let validSession = session else { return }
        
        validSession.end()
    }
}
