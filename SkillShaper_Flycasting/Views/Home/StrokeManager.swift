//
//  StrokeManager.swift
//  SkillShaper_Flycasting
//
//  Created by PUA on 6/29/21.
//  Copyright © 2021 skillshaper.us. All rights reserved.
//

import Foundation
import CoreGraphics
import CoreMotion
import SwiftUI
import Combine

enum AccAxis {
    case main
    case lateral
    case vertical
}

enum AccSource {
    case local
    case remote
}

class StrokeManager{
    let maxSample = 2000
    var tempCounter = 0
    var dataOffset = 0
    var dataStart = 0
    var dataEnd = 300
    var dataSegment = 0
    var accDataMain = [Double]()
    var accDataLateral = [Double]()
    var accDataVertical = [Double]()
    var isLogging = false
    var centerY:CGFloat = 0
    var lineDiv:CGFloat = 0
    var timer:Timer?
    var totalDivision = 16
    var acc:CMDeviceMotion?
    var accMain:Double = 0
    var accLateral:Double = 0
    var accVertical:Double = 0
    var viewWidth:CGFloat = 0
    var audioService:AudioService2?
    var loadedFile:String?
    let dataManager = SessionDataManager()
    var motionCanceller: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    private var remoteSettingsStore:SettingsStore?
    private var remotePublisher: Published<CMAcceleration>.Publisher?
    private var localPublisher: Published<CMAcceleration>.Publisher?
    
    func setLocalMotionSource(source: Published<CMAcceleration>.Publisher){
        localPublisher = source

    }
    
    func setRemoteMotionSource(settingsStore: SettingsStore,  source: Published<CMAcceleration>.Publisher){
        remotePublisher = source
        remoteSettingsStore = settingsStore
    }
    
    func setMotionSource(accSource:AccSource){
        var source: Published<CMAcceleration>.Publisher
        var isRemote = false
        switch(accSource){
        case .local:
            source = localPublisher!
        case .remote:
            isRemote = true
            source = remotePublisher!
        }
        audioService = AudioService2(publisher: source)
        audioService!.isRemote = isRemote
        audioService!.remoteSettingsStore = remoteSettingsStore
        if(motionCanceller != nil){
            motionCanceller?.cancel()
        }
        motionCanceller = source.sink { [weak self] acc in
            self?.updateAcceleration(acceleration: acc)
        }
    }
    
    
    func getLineOffset(lineLevel:Int)->CGFloat{
        var offset:CGFloat = 0
        if lineLevel == 0{
            offset = CGFloat(lineLevel)*lineDiv
        }else if lineLevel == totalDivision{
            offset = CGFloat(lineLevel)*lineDiv-20
        }else{
            offset = CGFloat(lineLevel)*lineDiv-10
        }
        return offset
    }

    func getTotalDivision()->Int{
        return totalDivision
    }

    func getAccelerationMain()->Double{
        return accMain
    }
    
    func getAccelerationLateral()->Double{
        return accLateral
    }
    
    func start(){
        accDataMain.removeAll()
        accDataLateral.removeAll()
        accDataVertical.removeAll()
        isLogging = true
        configAudio()
        audioService?.play()
    }
    
    private func configAudio(){
        let settingsStore = PhoneStore()
        var skill = settingsStore.skill
        var hears = [Hear]()
        switch settingsStore.skill {
        case .allMoves:
            hears.append(.fore)
            hears.append(.back)
            skill = .allMoves
        case .stroke:
            let strokeF = UserDefaults.standard.string(forKey: "strokeFore")
            if(strokeF == "true"){
                hears.append(.fore)
            }
            let strokeB = UserDefaults.standard.string(forKey: "strokeBack")
            if(strokeB == "true"){
                hears.append(.back)
            }
        case .stop:
            skill = .stop
            let stopF = UserDefaults.standard.string(forKey: "stopFore")
            if(stopF == "true"){
                hears.append(.fore)
            }
            let strokeB = UserDefaults.standard.string(forKey: "stopBack")
            if(strokeB == "true"){
                hears.append(.back)
            }
        case .straight:
            skill = .straight
        default:
            skill = Skill.stroke
        }

        audioService?.configurate(for: skill,hears: hears);
    }
    
    func stop(){
        audioService?.stop()
        isLogging = false
    }
    
    func saveData(){
        dataManager.saveData(dataPrimary: accDataMain,dataLateral: accDataLateral,dataVertical: accDataVertical)
        print("dfx - saveData - " + String(accDataMain.count))
        clearMotionData()
        
    }
    
    func deleteDataFile(fileName:String){
        dataManager.deleteData(fileName: fileName)
    }
    
    func loadDataFromFile(fileName:String){
        var data:String = dataManager.loadData(fileName: fileName)
        loadMotionFromData(data: data)
        loadedFile = fileName
    }
    
    func getDataFromFile(fileName:String)->String{
        return dataManager.loadData(fileName: fileName)
    }
    
    func loadMotionFromData(data:String){
        clearMotionData()
        var dataSub = data.components(separatedBy: "<data>")[1]
        dataSub = dataSub.components(separatedBy: "</data>")[0]
        var entries = dataSub.components(separatedBy: "\n")
            entries.forEach { entry in
                var vals = entry.components(separatedBy: "\t")
                if(vals.count == 3){
                    accDataMain.append(Double(vals[0])!)
                    accDataLateral.append(Double(vals[1])!)
                    accDataVertical.append(Double(vals[2])!)
                }
            }
    }
    
    func clearMotionData(){
        accDataMain.removeAll()
        accDataLateral.removeAll()
        accDataVertical.removeAll()
    }
    
    
    func updateAcceleration(acceleration: CMAcceleration){
        if(isLogging){
            accMain = acceleration.x * MotionManager.accMultiplier
            accVertical = acceleration.y * MotionManager.accMultiplier
            accLateral = acceleration.z * MotionManager.accMultiplier
            if(accDataMain.count>maxSample){
                accDataMain.removeFirst();
                accDataLateral.removeFirst();
                accDataVertical.removeFirst();
                
            }
            accDataMain.append(acceleration.x)
            accDataLateral.append(acceleration.z)
            accDataVertical.append(acceleration.y)
        }
        
    }
    
    func createGrid(width:CGFloat,height:CGFloat)->Path{
        totalDivision = 16
        if viewWidth == 0{
            viewWidth = width
            dataEnd = Int(viewWidth)
        }
        var path = Path()
        lineDiv = height/CGFloat(totalDivision)
        for c in 0...totalDivision{
            let  yPos = CGFloat(CGFloat(c)*lineDiv)
            path.move(to: CGPoint(x: 0, y: yPos))
            path.addLine(to: CGPoint(x: width, y: yPos))
        }
        return path
    }
    
    func createGridOffset(width:CGFloat,height:CGFloat, graphOffset: CGSize)->Path{
        totalDivision = 16
        if viewWidth == 0{
            viewWidth = width
            dataEnd = Int(viewWidth)
        }
        var path = Path()
        lineDiv = height/CGFloat(totalDivision)
        for c in 0...totalDivision{
            let  yPos = CGFloat(CGFloat(c)*lineDiv)
            path.move(to: CGPoint(x: 0, y: yPos))
            path.addLine(to: CGPoint(x: width, y: yPos))
        }
        return path
    }
    
    
    func createCenterLine(width:CGFloat,height:CGFloat)->Path{
        let totalDivision = 16
        let div = height/CGFloat(totalDivision)
        var centerLine = Path()
        let  yPos = CGFloat(CGFloat(totalDivision/2)*div)
        centerY = yPos
        centerLine.move(to: CGPoint(x: 0, y: yPos))
        centerLine.addLine(to: CGPoint(x: width, y: yPos))
        return centerLine
    }
    
    func createGraphFilled(accAxis:AccAxis,fillPositive:Bool,fillNegative:Bool)->Path{
        var data:[Double]?
        switch accAxis{
        case .main:
            data = accDataMain
        case .lateral:
            data = accDataLateral
        case .vertical:
            data = accDataVertical
        }
        var path = Path()
        var y:CGFloat = 0
        if accDataMain.count>0{
            let endFrame = min(accDataMain.count,dataEnd)
            for i in dataStart...endFrame-1{
                y = CGFloat(data![i] * -1)
                if(fillPositive && y<=0) || (fillNegative && y>0){
                    path.move(to: CGPoint(x: CGFloat(i-dataStart), y: centerY))
                    path.addLine(to: CGPoint(x: CGFloat(i-dataStart), y: centerY-y*50))
                }
                    
            }
        }
        return path
    }
    
    func createGraph(accAxis:AccAxis)->Path{
        var data:[Double]?
        switch accAxis{
        case .main:
            data = accDataMain
        case .lateral:
            data = accDataLateral
        case .vertical:
            data = accDataVertical
        }
        var path = Path()
        var y:CGFloat = 0
        let point = CGPoint(x: 0, y: centerY)
        if data!.count>0{
            path.move(to: point)
            let endFrame = min(accDataMain.count,dataEnd)
            for i in dataStart...endFrame-1{
                y = CGFloat(data![i] * -1)
                path.addLine(to: CGPoint(x: CGFloat(i-dataStart), y: centerY-y*50))
            }
        }

        return path
    }
    
    func updateAccMainDisplay(strength:Double,width:CGFloat,height:CGFloat)->Path{
        var path = Path()
        var x = width/2
        var y = height/2
        path.move(to: CGPoint(x: x, y: y))
        path.addLine(to: CGPoint(x:x-CGFloat(strength/2)*60, y:y+CGFloat(strength/2)*60))
        return path
    }
    
    func updateAccLateralDisplay(strength:Double,width:CGFloat,height:CGFloat)->Path{
        var path = Path()
        var x = width/2
        var y = height/2
        path.move(to: CGPoint(x: x, y: y))
        path.addLine(to: CGPoint(x:x-CGFloat(strength)*60, y: CGFloat(y)))
        return path
    }
    
    func offsetChart(offset:Int){
        if(accDataMain.count > Int(viewWidth)){
            let nOffset = -offset
            dataStart = min(max(0,dataSegment + nOffset),accDataMain.count-Int(viewWidth))
            dataEnd = dataStart+Int(viewWidth)
        }
    }
    
    func updateOffset(){
        dataSegment = dataStart
    }
    
    func getFileList()->[URL]{
        return dataManager.getFileList(folder: "MotionData")
    }
}

