//
//  MainViewModel.swift
//  Skillshaper SwiftUI WatchKit Extension
//

import SwiftUI
import Combine

class MainViewModel: ObservableObject {
    
    private let workoutService: WorkoutService
    private let motionService: MotionService
    private let connectivityService: ConnectivityService
    
    let settingsStore = SettingsStore()
    
    @Published var isPlaying: Bool = false
    
    var title: String {
        
        isPlaying ? "Stop" : "Start"
    }
    
    var color: Color {
        
        isPlaying ? .red : .green
    }
    
    init() {
        
        self.workoutService = WorkoutService()
        self.motionService = MotionService(settingsStore: settingsStore)
        self.connectivityService = ConnectivityService(store: settingsStore, publisher: motionService.$sensorValue, publisher2: motionService.$sensorsXYZValues)
    }
    
    func togglePlaying() {
        
        isPlaying.toggle()
        
        settingsStore.isPlaying = isPlaying
        
        if isPlaying {
            
            workoutService.startSession()
            motionService.startUpdating()
        } else {

            workoutService.stopSession()
            motionService.stopUpdating()
        }
    }
}
