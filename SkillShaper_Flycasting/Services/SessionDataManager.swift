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
        formatter.dateFormat = "MM.dd HH:mm:ss"
    }
    
    func saveData(dataPrimary:[Double], dataLateral:[Double], dataVertical:[Double]){
        var sessionText = _addHeader()
        sessionText += _addData(dataPrimary:dataPrimary, dataLateral:dataLateral, dataVertical:dataVertical)
        sessionText += _addAnnotations()
        var fileName = formatter.string(from: Date()) + ".txt"
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
    
    
    
    func _addHeader()->String{
        return "<header>\n</header>\n"
    }

    func _addData(dataPrimary:[Double], dataLateral:[Double], dataVertical:[Double])->String{
        var dataText = "<data>\n"
        for i in 0..<dataPrimary.count {
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
