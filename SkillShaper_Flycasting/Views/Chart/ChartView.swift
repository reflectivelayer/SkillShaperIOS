//
//  ChartView.swift
//  SkillShaper_Flycasting
//
//  Created by PUA on 7/1/21.
//  Copyright © 2021 skillshaper.us. All rights reserved.
//

import SwiftUI

struct ChartGrid:View {
    @Binding var dataSources:Set<AccAxis>
    @Binding var fillPositive:Bool
    @Binding var fillNegative:Bool
    @Binding var offset:CGSize
    
    var body: some View{
        GeometryReader{geo in
            
            strokeManager.createGridOffset(width: geo.size.width, height: geo.size.height, graphOffset: offset).stroke(style: StrokeStyle(lineWidth: 1,dash: [5])).offset(x:strokeManager.chartXoffset, y:0).foregroundColor(Color.black)
            
            strokeManager.createCenterLine(width: geo.size.width, height: geo.size.height).stroke(style: StrokeStyle(lineWidth: 4)).offset(x:strokeManager.chartXoffset, y:0).foregroundColor(Color.black)
            
            if (fillNegative && dataSources.count == 1) {
                strokeManager.createGraphFilled(accAxis:dataSources.first!,fillPositive:true,fillNegative:false).stroke(Color.red,lineWidth: 2).offset(x:strokeManager.chartXoffset, y:0)
            }
             
            
            if (fillPositive && dataSources.count == 1) {
                strokeManager.createGraphFilled(accAxis:dataSources.first!,fillPositive:false,fillNegative:true).stroke(Color.green,lineWidth: 2).offset(x:strokeManager.chartXoffset, y:0)
            }
            
            if(dataSources.contains(AccAxis.main)){
                strokeManager.createGraph(accAxis:AccAxis.main).stroke(Color.black,lineWidth: 2).offset(x:strokeManager.chartXoffset, y:0)
            }
            if(dataSources.contains(AccAxis.lateral)){
                strokeManager.createGraph(accAxis:AccAxis.lateral).stroke(Color.red,lineWidth: 2).offset(x:strokeManager.chartXoffset, y:0)
            }
            if(dataSources.contains(AccAxis.vertical)){
                strokeManager.createGraph(accAxis:AccAxis.vertical).stroke(Color.blue,lineWidth: 2).offset(x:strokeManager.chartXoffset, y:0)
            }

            //Legend
            ForEach(0..<strokeManager.getTotalDivision()+1){count in
                Text(String(strokeManager.getTotalDivision()/2-count) + ".0 g").offset(x: 0, y: CGFloat(strokeManager.getLineOffset(lineLevel:count))).foregroundColor(Color.black)
            }
            
            
        }.onAppear{
            strokeManager.offsetChart(offset: Int(offset.width))
        }
    }
}

