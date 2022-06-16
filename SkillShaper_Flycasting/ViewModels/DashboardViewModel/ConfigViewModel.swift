//
//  ConfigViewModel.swift
//  Skillshaper SwiftUI
//

import SwiftUI
import Combine

class ConfigViewModel: ObservableObject {
    
    private var isPlayingSubscriber: AnyCancellable!
    private var skillSubscriber: AnyCancellable!
    private var hearsSubscriber: AnyCancellable!
    private var watchPositionSubscriber: AnyCancellable!
    
    @Published var isPlaying: Bool = false
    @Published var isPlayingTitle: String = "Stopped"
    @Published var skillTitle: String = Skill.stroke.name
    @Published var hearsTitle: String = Hear.fore.name
    @Published var watchPositionTitle: String = WatchPosition.wRod.name
    @Published var watchPositionIsShowed: Bool = false
    
    init(settingsStore: SettingsStore) {
        
        isPlayingSubscriber = settingsStore.$isPlaying.sink { [weak self] isPlaying in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                self.isPlayingTitle = isPlaying ? "Running" : "Stopped"
                self.isPlaying = isPlaying
            }
        }
        
        skillSubscriber = settingsStore.$skill.sink { [weak self] skill in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                self.skillTitle = skill.name
                self.watchPositionIsShowed = skill == .straight
            }
        }
        
        hearsSubscriber = settingsStore.$hears.sink { [weak self] hearOn in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                if hearOn.count > 1 {
                    
                    self.hearsTitle = "\(Hear.fore.name) and \(Hear.back.name)"
                    
                    return
                }
                
                self.hearsTitle = hearOn.first?.name ?? ""
            }
        }
        
        watchPositionSubscriber = settingsStore.$watchPosition.sink { [weak self] watchPosition in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                self.watchPositionTitle = watchPosition.name
            }
        }
    }
}
