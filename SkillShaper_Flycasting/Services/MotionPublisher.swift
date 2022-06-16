//
//  MotionService.swift
//  SkillShaper_Flycasting
//
//  Created by PUA on 10/5/21.
//  Copyright © 2021 skillshaper.us. All rights reserved.

import Foundation
import Combine

class MotionPublisher: ObservableObject{
    @Published var sensorValue: Double = 0
    var timer: AnyCancellable?
    
    init(){
    }
    
    func update(data:Double){
        sensorValue = data
    }
}
