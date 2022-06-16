//
//  SettingsViewModel.swift
//  SkillShaper_Flycasting
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    
    private let userDefaultsService: UserDefaultsService
    
    private var cancellables = Set<AnyCancellable>()
    
    let settingsStore: SettingsStore
    
    @Published var watchPositionIsShowed: Bool = false
    
    init(settingsStore: SettingsStore) {
        
        self.settingsStore = settingsStore
        self.userDefaultsService = UserDefaultsService(settingsStore: settingsStore)
        
        settingsStore.$skill.sink { [weak self] skill in
            
            guard let self = self else { return }
            
//            self.settingsStore.hears = [.fore]
//            self.settingsStore.watchPosition = .wRod
            
            self.watchPositionIsShowed = skill == .straight
        }.store(in: &cancellables)
    }
    
    func resetSettings() {
        
        settingsStore.skill = .stroke
        settingsStore.hears = [.fore]
        settingsStore.watchPosition = .wRod
    }
}
