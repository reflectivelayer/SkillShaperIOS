//
//  AccStrengthView.swift
//  SkillShaper_Flycasting
//
//  Created by PUA on 7/2/21.
//  Copyright © 2021 skillshaper.us. All rights reserved.
//

import SwiftUI

struct AccStrengthView:View {
    @ObservedObject var motion: MotionManager
    
    var body: some View{
        GeometryReader{geo in
            strokeManager.updateAccMainDisplay(strength:motion.acc.x, width: geo.size.width, height:geo.size.height).stroke(Color.yellow,lineWidth: 5)
            strokeManager.updateAccLateralDisplay(strength:motion.acc.y, width: geo.size.width, height:geo.size.height).stroke(Color.red,lineWidth: 5)
        }
    }
}
