//
//  ChartView.swift
//  SkillShaper_Flycasting
//
//  Created by PUA on 7/1/21.
//  Copyright © 2021 skillshaper.us. All rights reserved.
//

import SwiftUI

struct ChartGrid:View {
    @Binding var dataSource:AccAxis
    @Binding var fillPositive:Bool
    @Binding var fillNegative:Bool
    @Binding var offset:CGSize
    
    
    var body: some View{
        GeometryReader{geo in
            
            strokeManager.createGridOffset(width: geo.size.width, height: geo.size.height, graphOffset: offset).stroke(style: StrokeStyle(lineWidth: 1,dash: [5])).offset(x:50, y:0).foregroundColor(Color.black)
            
            strokeManager.createCenterLine(width: geo.size.width, height: geo.size.height).stroke(style: StrokeStyle(lineWidth: 4)).offset(x:50, y:0).foregroundColor(Color.black)
            
            if fillNegative {
                strokeManager.createGraphFilled(accAxis:dataSource,fillPositive:true,fillNegative:false).stroke(Color.red,lineWidth: 2).offset(x:50, y:0)
            }
            
            if fillPositive {
                strokeManager.createGraphFilled(accAxis:dataSource,fillPositive:false,fillNegative:true).stroke(Color.green,lineWidth: 2).offset(x:50, y:0)
            }
            
            strokeManager.createGraph(accAxis:dataSource).stroke(Color.black,lineWidth: 2).offset(x:50, y:0)

            ForEach(0..<strokeManager.getTotalDivision()+1){count in
                Text(String(strokeManager.getTotalDivision()/2-count) + ".0 g").offset(x: 0, y: CGFloat(strokeManager.getLineOffset(lineLevel:count))).foregroundColor(Color.black)
            }
            
        }.onAppear{
            strokeManager.offsetChart(offset: Int(offset.width))
            print(offset)
        }
    }
}

