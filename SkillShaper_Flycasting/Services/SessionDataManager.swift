//
//  SessionDataManager.swift
//  SkillShaper_Flycasting
//
//  Created by PUA on 11/8/22.
//  Copyright © 2022 skillshaper.us. All rights reserved.
//

import Foundation
class SessionDataManager {

    func saveData(dataPrimary:[Double], dataLateral:[Double], dataVertical:[Double]){
        var sessionText = _addHeader()
        sessionText += _addData(dataPrimary:dataPrimary, dataLateral:dataLateral, dataVertical:dataVertical)
        sessionText += _addAnnotations()
        _saveToDisk(fileName: "dfx", text: sessionText)
        print(sessionText)
    }
    
    func loadData(filenName:String) -> String{
        var data = ""
        do{
            let directory = try FileManager.default.url(
                for: .documentDirectory,
                   in: .userDomainMask,
                   appropriateFor: nil,
                   create: true
            )
            data = try String(
                contentsOf: directory.appendingPathComponent(filenName), encoding: .utf8)
        }catch{
            
        }
        return data
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
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)[0].appendingPathComponent(fileName)

        if let stringData = text.data(using: .utf8) {
            try? stringData.write(to: path)
        }
    }
    
}
