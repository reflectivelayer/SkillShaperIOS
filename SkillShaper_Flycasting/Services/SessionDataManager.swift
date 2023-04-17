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
    init(){
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MM.dd HH:mm:ss:"
    }
    
    func saveData(loggedTime:Double,dataPrimary:[Double], dataLateral:[Double], dataVertical:[Double]){
        var sessionText = _addHeader(duration: loggedTime)
        sessionText += _addData(dataPrimary:dataPrimary, dataLateral:dataLateral, dataVertical:dataVertical)
        sessionText += _addAnnotations()
        var fileName = formatter.string(from: Date()) + "(" + String(Int(loggedTime)) + "secs).txt"
        _saveToDisk(fileName: fileName, text: sessionText)
        print(loggedTime)

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
            print(url.lastPathComponent)
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
    
    
    
    func _addHeader(duration:Double)->String{
        return "<header>\n<duration>\n" + String(Int(duration)) + "\n</duration>\n</header>\n"
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
