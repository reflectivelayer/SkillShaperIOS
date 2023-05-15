//
//  SessionDataManager.swift
//  SkillShaper_Flycasting
//
//  Created by PUA on 11/8/22.
//  Copyright © 2022 skillshaper.us. All rights reserved.
//

import Foundation
class SessionDataManager {
    let formatter = DateFormatter()
    var headerText = ""
    
    init(){
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MM.dd HH:mm:ss:"
    }
    
    func saveData(loggedTime:Double,dataPrimary:[Double], dataLateral:[Double], dataVertical:[Double]){
        
        
        var sessionText = headerText
        
        sessionText += _addData(dataPrimary:dataPrimary, dataLateral:dataLateral, dataVertical:dataVertical)
        sessionText += _addAnnotations()
        var fileName = formatter.string(from: Date()) + "(" + String(Int(loggedTime)) + "secs).txt"
        _saveToDisk(fileName: fileName, text: sessionText)
  

    }
    
    func getFileList(folder:String)->[URL]{
        var docList:[URL] = []
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory,
            in:.userDomainMask)[0]
        let motionPath = documentsPath.path + "/MotionData"
        do {
            docList = try fileManager.contentsOfDirectory(at:URL(fileURLWithPath:motionPath), includingPropertiesForKeys: nil)
        } catch {
            print("Error while enumerating files \(motionPath): \(error.localizedDescription)")
        }
        for url in docList {
            //print(url.lastPathComponent)
        }
        return docList
    }
    
    func loadData(fileName:String)->String{
        var data = ""
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory,
            in:.userDomainMask)[0]
        let motionPath = documentsPath.path + "/MotionData"
        do {
            data = try String(
                contentsOf: URL(fileURLWithPath:motionPath).appendingPathComponent(fileName), encoding: .utf8)
        } catch {
            print("Error while enumerating files \(motionPath): \(error.localizedDescription)")
        }
        return data
    }
    
    
    func deleteData(fileName:String){
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory,
            in:.userDomainMask)[0]
        let motionPath = documentsPath.path + "/MotionData"
        
        do {
            try fileManager.removeItem(at: URL(fileURLWithPath:motionPath).appendingPathComponent(fileName))
        } catch {
            print("Error while enumerating files \(motionPath): \(error.localizedDescription)")
        }
    }
    
    
    func setHeader(duration:Double,
                    appDevice:String,
                    rightHandGrip:Bool,
                    currentSkill:Int,
                    dataPointCount:Int,
                    sensorIntervalPresetInMS:Int,
                    soundOnPositiveReading:Bool,
                    soundOnNegativeReading:Bool,
                    noAudioBelowThisReading:Float,
                    noAudioAboveThisReading:Float){
        var appName = Bundle.main.infoDictionary?["CFBundleName"] as! String ?? ""
        var appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String ?? ""
        var appEdition = Bundle.main.infoDictionary?["AppEdition"] as! String ?? ""

        var h1 = "<header>\n"
        var d1 = keyValueToString(key: "AppName", value: appName)
        var d2 = keyValueToString(key: "AppVersion", value: appVersion)
        var d3 = keyValueToString(key: "AppEdition", value: appEdition)
        var d4 = keyValueToString(key: "AppDevice", value: appDevice)
        var d5 = keyValueToString(key: "RightHandGrip", value: String(rightHandGrip))
        var d6 = keyValueToString(key: "CurrentSkill", value: String(currentSkill))
        var d7 = keyValueToString(key: "Duration", value: String(Int(duration)))
        var d8 = keyValueToString(key: "DataPointCount", value: String(dataPointCount))
        var d9 = keyValueToString(key: "SensorIntervalPresetInMS", value: String(sensorIntervalPresetInMS))
        var d10 = keyValueToString(key: "SoundOnPositiveReading", value: String(soundOnPositiveReading))
        var d11 = keyValueToString(key: "SoundOnNegativeReading", value: String(soundOnNegativeReading))
        var d12 = keyValueToString(key: "NoAudioBelowThisReading", value: String(Float(noAudioBelowThisReading)))
        var d13 = keyValueToString(key: "NoAudioAboveThisReading", value: String(Float(noAudioAboveThisReading)))
        var h2 = "</header>\n"
        
        headerText = h1+d1+d2+d3+d4+d5+d6+d7+d8+d9+d10+d11+d12+d13+h2
        //print(headerText)
    }
    
    func keyValueToString(key:String, value:String)->String{
        var h1:String = "<"+key+">"
        var h2:String = "</"+key+">\n"
        return h1+value+h2
        
    }

    func _addData(dataPrimary:[Double], dataLateral:[Double], dataVertical:[Double])->String{
        let count = min(dataPrimary.count,dataLateral.count,dataVertical.count)
        var dataText = "<data>\n"
        for i in 0..<count {
            dataText += String(format: "%.2f", dataPrimary[i]) + "\t"
            + String(format: "%.2f", dataLateral[i]) + "\t"
            + String(format: "%.2f", dataVertical[i]) + "\n"
        }
        dataText+="</data>\n"
        return dataText
    }
    
    func _addAnnotations()->String{
        return "<annotations>\n</annotations>"
    }
    
    func _saveToDisk(fileName:String, text:String){
        let documentsPath = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)[0]
        let motionPath = documentsPath.path + "/MotionData"
        if !FileManager.default.fileExists(atPath: motionPath) {
            do {
                try FileManager.default.createDirectory(atPath: motionPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription);
            }
        }
        let path = motionPath + "/" + fileName
        if let stringData = text.data(using: .utf8) {
            try? stringData.write(to: URL(fileURLWithPath: path))
        }
    }
    
}
