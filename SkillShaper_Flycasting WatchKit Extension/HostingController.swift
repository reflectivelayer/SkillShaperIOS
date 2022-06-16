//
//  HostingController.swift
//  SkillShaper_Flycasting WatchKit Extension
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<Main> {

    private let mainViewModel = MainViewModel()
    
    override var body: Main {
        
        return Main(viewModel: mainViewModel)
    }
}
