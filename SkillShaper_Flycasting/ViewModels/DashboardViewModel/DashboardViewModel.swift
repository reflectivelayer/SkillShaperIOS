//
//  DashboardViewModel.swift
//  SkillShaper_Flycasting
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import Foundation
import Combine

class DashboardViewModel {
    
    private let settingsStore = SettingsStore()
    private let connectivityService: ConnectivityService
    //private let audioService: AudioService
    
    let configViewModel: ConfigViewModel
    
    init() {
        
        self.configViewModel = ConfigViewModel(settingsStore: settingsStore)
        self.connectivityService = ConnectivityService(settingsStore: settingsStore)
       // self.audioService = AudioService(settingsStore: settingsStore, publisher: connectivityService.$sensorValueXYZ)
       // self.audioService.play()
        strokeManager.setRemoteMotionSource(settingsStore: settingsStore, source: connectivityService.$sensorValueXYZ)
    }
}


