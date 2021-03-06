//
//  SettingsController.swift
//  SkillShaper_Flycasting
//
//  Created by user on 6/26/21.
//  Copyright © 2021 skillshaper.us. All rights reserved.
//

import SwiftUI

 struct SettingsContoller: View {

    let greenBtn = Color(red: 76.0/255, green: 84.0/255, blue: 75.0/255)

    @State var strokeBox = false
    @State var strokeForeBox = false
    @State var strokeBackBox = false
    @State var straightBox = true
    @State var stopBox = true
    @State var stopForeBox = false
    @State var stopBackBox = false
    @State var leftBtn = true
    @State var rightBtn = true

    func  strokeForeToggle(){
        strokeForeBox = !strokeForeBox
        saveSettings(name: "strokeFore", value: strokeForeBox ? "true" : "false")
     }
    
    func  strokeBackToggle(){
        strokeBackBox = !strokeBackBox
        saveSettings(name: "strokeBack", value: strokeBackBox ? "true" : "false")
     }
    
    func  stopForeToggle(){
        stopForeBox = !stopForeBox
        saveSettings(name: "stopFore", value: stopForeBox ? "true" : "false")
     }
    
    func  stopBackToggle(){
        stopBackBox = !stopBackBox
        saveSettings(name: "stopBack", value: stopBackBox ? "true" : "false")
     }
    
    func  skillToggle(skillType:String){
        clearSkills()
        switch(skillType){
            case "stroke":
                strokeBox = true
                break
            case "straight":
                straightBox = true
                break
            case "stop":
                stopBox = true
                break
            default:
                break
        }
        saveSettings(name: "skill", value: skillType)
    }

    func  handToggle(hand:String){
        if(hand == "left"){
            if(!leftBtn){
                leftBtn = true
                rightBtn = false
                if(strokeBox && xor(a: strokeForeBox,b: strokeBackBox)){
                    strokeForeToggle()
                    strokeBackToggle()
                }else if(stopBox && xor(a: stopForeBox,b: stopBackBox)){
                    stopForeToggle()
                    stopBackToggle()
                }
            }
        }else{
            if(leftBtn){
                leftBtn = false
                rightBtn = true
                if(strokeBox && xor(a: strokeForeBox,b: strokeBackBox)){
                    strokeForeToggle()
                    strokeBackToggle()
                }else if(stopBox && xor(a: stopForeBox,b: stopBackBox)){
                    stopForeToggle()
                    stopBackToggle()
                }
            }
        }
        
        saveSettings(name: "hand", value: hand)
     }
    
    func clearSkills(){
        strokeBox = false
        straightBox = false
        stopBox = false
    }
    
    func xor(a:Bool, b:Bool)->Bool{
        return(a && !b) || (!a && b)
    }

    func goHome() {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: HomeView(viewModel:viewModel.configViewModel,motion: MotionManager()))
            window.makeKeyAndVisible()
        }
    }
    
    func loadSettings(){
        let hand = UserDefaults.standard.string(forKey: "hand")
        if(hand == "left"){
            leftBtn = true
            rightBtn = false
        }else{
            leftBtn = false
            rightBtn = true
        }

        clearSkills()
        let skill = UserDefaults.standard.string(forKey: "skill")
        if(skill == "stroke"){
            strokeBox = true
        }else if(skill == "straight"){
            straightBox = true
        }else if(skill == "stop"){
            stopBox = true
        }
   
        let strokeFore = UserDefaults.standard.string(forKey: "strokeFore")
        if(strokeFore == "true"){
            strokeForeBox = true
        }else{
            strokeForeBox = false
        }

        let strokeBack = UserDefaults.standard.string(forKey: "strokeBack")
        if(strokeBack == "true"){
            strokeBackBox = true
        }else{
            strokeBackBox = false
        }
        
        let stopFore = UserDefaults.standard.string(forKey: "stopFore")
        if(stopFore == "true"){
            stopForeBox = true
        }else{
            stopForeBox = false
        }

        let stopBack = UserDefaults.standard.string(forKey: "stopBack")
        if(stopBack == "true"){
            stopBackBox = true
        }else{
            stopBackBox = false
        }
    }

    func reloadDefaults() {
        leftBtn = false
        rightBtn = true
        clearSkills()
        strokeBox = true
        strokeForeBox = true
        strokeBackBox = false
        stopForeBox = true
        stopBackBox = false
        
        saveSettings(name: "left", value: "false")
        saveSettings(name: "right", value: "true")
        saveSettings(name: "skill", value: "stroke")
        saveSettings(name: "strokeFore", value: "true")
        saveSettings(name: "strokeBack", value: "false")
        saveSettings(name: "stopFore", value: "true")
        saveSettings(name: "stopBack", value: "false")
    }

    
    func saveSettings(name:String, value:String){
        UserDefaults.standard.set(value,forKey: name)
    }
    
    var body: some View {
        VStack{
            Text(" ")
            Text("Skill Selection")
            .bold()
            .font(.system(size: 24))
            .foregroundColor(.white)
        }
        VStack(alignment: .leading, spacing: 0){
            
            Text(" ")
            HStack{
                Spacer()
                Text("Which hand are you using")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                Button(action: {
                    handToggle(hand: "left")
                    print("left radio btn")
                    print(leftBtn)
                }) {

                    HStack{
                        Image(systemName: leftBtn ? "largecircle.fill.circle" : "circle")
                            .padding(3)
                            .foregroundColor(.white)

                        VStack{
                        Text("Left")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                        }
                    }
                }

                Button(action: {
                    handToggle(hand: "right")
                    print("right radio btn")
                    print(rightBtn)
                }) {

                    HStack{
                        Image(systemName: rightBtn ? "largecircle.fill.circle" : "circle")
                            .padding(3)
                            .foregroundColor(.white)

                        VStack{
                        Text("Right")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                        }
                    }
                }
            }
            //=======================================================================
  
        ZStack{
            Color.black
            VStack(spacing: 14){
                
            Text("Select a skill to work on")
                .foregroundColor(.white)
                .bold()
                .font(.system(size: 21))
            Text(" ")
            Button(action: {
                skillToggle(skillType: "stroke")
                print("stroke check box")
                print(strokeBox)
            }) {
            
            HStack{
                Image(systemName: strokeBox ? "checkmark.square" : "square" )
                        .padding(3)
                        .foregroundColor(.white)

                    HStack{
                    Text("Stroke move")
                        .font(.system(size: 17))
                        .bold()
                        .foregroundColor(.white)
                    }
                }
                Text("Practice smooth acceleration")
                    .foregroundColor(.white)
                    .font(.system(size: 14))
            }
               
            HStack{
                Spacer()
                Button(action: {
                    strokeForeToggle()
                    print("stroke fore check box")
                    print(strokeForeBox)
                }) {
                    Text("Listen to")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                    HStack{
                        Image(systemName: strokeForeBox ? "checkmark.square" : "square")
                            .padding(3)
                            .foregroundColor(.white)

                        VStack{
                        Text("fore")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                        }
                    }
                }

                Button(action: {
                    strokeBackToggle()
                    print("stroke back check box")
                    print(strokeBackBox)
                }) {
                    
                    HStack{
                        Image(systemName: strokeBackBox ? "checkmark.square" : "square")
                            .padding(3)
                            .foregroundColor(.white)

                        VStack{
                        Text("back  ")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                        }
                    }
                }

            }
            HStack{
                
                Button(action: {
                    skillToggle(skillType: "straight")
                    print("straight check box")
                    print(straightBox)
                }) {

                HStack{
                    Text("   ")
                    Image(systemName: straightBox ? "checkmark.square" : "square")
                        .padding(3)
                        .foregroundColor(.white)

                    HStack{
                    Text("Straight move")
                        .font(.system(size: 17))
                        .bold()
                        .foregroundColor(.white)
                    }
                }

                Text("Keeping in a straight line")
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                }
                Spacer()
        }
            Text(" ")
            HStack{
                Button(action: {
                    skillToggle(skillType: "stop")
                    print("stop check box")
                    print(stopBox)
                }) {
                    HStack{
                      Text("   ")
                        Image(systemName: stopBox ? "checkmark.square" : "square")
                            .padding(3)
                            .foregroundColor(.white)

                        HStack{
                        Text("Stop move")
                            .font(.system(size: 17))
                            .bold()
                            .foregroundColor(.white)
                        }
                    }

                    Text("Stopping crisply")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                }
                    Spacer()
            }
            
            HStack{
                Spacer()

                Button(action: {
                    stopForeToggle()
                    print("stop fore check box")
                    print(stopForeBox)
                }) {
                    Text("Listen to")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                    HStack{
                        Image(systemName: stopForeBox ? "checkmark.square" : "square")
                            .padding(3)
                            .foregroundColor(.white)

                        VStack{
                        Text("fore")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                        }
                    }
                }

                Button(action: {
                    stopBackToggle()
                    print("stop back check box")
                    print(stopBackBox)
                }) {

                    HStack{
                        Image(systemName: stopBackBox ? "checkmark.square" : "square" )
                            .padding(3)
                            .foregroundColor(.white)

                        VStack{
                        Text("back")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                        }
                    }
                }
            }

            }
        }
     }.onAppear(){
        loadSettings()
    }
        HStack{
        
            Spacer()
            
            Button(action: {
            print("reset button")
            reloadDefaults()
            }) {
            Text("RESET")
                .padding(10)
                .font(.system(size: 17))
                .background(greenBtn)
                .foregroundColor(.white)
            }
            
            Spacer()
            
            Button(action: {
                goHome()
            }, label: {
                Text("< BACK <")
                    .padding(10)
                    .font(.system(size: 17))
                    .background(greenBtn)
                    .foregroundColor(.white)
            })
            
    }
        Text(" ")
  }
}
