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

    @State var allMovesBox = false
    @State var strokeBox = false
    @State var strokeForeBox = false
    @State var strokeBackBox = false
    @State var straightBox = true
    @State var straightLeftBox = false
    @State var straightRightBox = false
    @State var stopBox = false
    @State var stopForeBox = false
    @State var stopBackBox = false
    @State var leftBtn = true
    @State var rightBtn = true
    
    var body: some View {
        VStack(alignment:.leading){
            Text(" ")
            Text("Session Settings")
            .bold()
            .font(.system(size: 24))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .center)
            renderCastHand()
            Text("Move Selection")
                .foregroundColor(.yellow)
                .bold()
                .padding(20)
                .font(.system(size: 25))
                .frame(maxWidth: .infinity, alignment: .center)
            renderAllMoves()
            renderStroke()
            renderStraight()
            renderStop()
            Spacer()
            renderBottomBtn()
            
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
            .padding(10)
            .onAppear(){
             loadSettings()
            }
    }
     //===========================================================================
     
    func renderCastHand()->some View{
         return HStack{
         Text("Casting hand?")
             .foregroundColor(.white)
             .font(.system(size: 15)).bold()
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
    }
     
     
    func renderAllMoves()-> some View{
        return Button(action: {
            skillToggle(skillType: "allMoves")
            print("stroke check box")
            print(strokeBox)
            
        }) {
            HStack{
                 Image(systemName: allMovesBox ? "checkmark.square" : "square" )
                         .padding(3)
                         .foregroundColor(.white)

                     HStack{
                     Text("All moves")
                         .font(.system(size: 20))
                         .bold()
                         .foregroundColor(.yellow)
                     }
                 }
                 Text("Hear all movements")
                     .foregroundColor(.white)
                     .font(.system(size: 15))
             }
     }
     
     
     func renderStroke()->some View{
         return VStack{
                 HStack{
                     Button(action: {
                            skillToggle(skillType: "stroke")
                        }) {
                             Image(systemName: strokeBox ? "checkmark.square" : "square")
                                 .padding(3)
                                 .foregroundColor(.white)
                         }
                         Text("Stroke")
                             .font(.system(size: 20))
                             .bold()
                             .foregroundColor(.yellow)
        
                         
                         Text("Accelerate smoothly")
                             .foregroundColor(.white)
                             .font(.system(size: 15))
                         Spacer()
                 }
                 if(strokeBox){
                     HStack{
                       Text("   ")
                         Button(action: {
                             strokeForeToggle()
                         }) {
                             Image(systemName: strokeForeBox ? "checkmark.square" : "square")
                                 .padding(3)
                                 .foregroundColor(.white)
                         }
                         Text("fore")
                             .font(.system(size: 15))
                             .foregroundColor(.white)
                             
                         Button(action: {
                             strokeBackToggle()
                         }) {
                         Image(systemName: strokeBackBox ? "checkmark.square" : "square")
                             .padding(3)
                             .foregroundColor(.white)
                         }
                         Text("back")
                             .font(.system(size: 15))
                             .foregroundColor(.white)
                         
                         Text("direction to hear")
                             .font(.system(size: 15))
                             .foregroundColor(.white)
                     }

             }
         }

     }
     
     
     
     func renderStraight()->some View{
         return VStack{
                 HStack{
                     Button(action: {
                             skillToggle(skillType: "straight")
                             print("straight check box")
                             print(straightBox)
                         }) {
                             Image(systemName: straightBox ? "checkmark.square" : "square")
                                 .padding(3)
                                 .foregroundColor(.white)
                         }
                         Text("Straight")
                             .font(.system(size: 20))
                             .bold()
                             .foregroundColor(.yellow)
        
                         
                         Text("Accelerate smoothly")
                             .foregroundColor(.white)
                             .font(.system(size: 15))
                         Spacer()
                 }
                 if(straightBox){
                     HStack{
                       Text("   ")
                         Button(action: {
                             straightLeftToggle()
                         }) {
                             Image(systemName: straightLeftBox ? "checkmark.square" : "square")
                                 .padding(3)
                                 .foregroundColor(.white)
                         }
                         Text("left")
                             .font(.system(size: 15))
                             .foregroundColor(.white)
                             
                         Button(action: {
                             straightRightToggle()
                         }) {
                         Image(systemName: straightRightBox ? "checkmark.square" : "square")
                             .padding(3)
                             .foregroundColor(.white)
                         }
                         Text("right")
                             .font(.system(size: 15))
                             .foregroundColor(.white)
                         
                         Text("direction to hear")
                             .font(.system(size: 15))
                             .foregroundColor(.white)
                     }

             }
         }

     }
     
     
     func renderStop()->some View{
         return VStack{
                 HStack{
                     Button(action: {
                            skillToggle(skillType: "stop")
                        }) {
                             Image(systemName: stopBox ? "checkmark.square" : "square")
                                 .padding(3)
                                 .foregroundColor(.white)
                         }
                         Text("Stop")
                             .font(.system(size: 20))
                             .bold()
                             .foregroundColor(.yellow)
        
                         
                         Text("Accelerate smoothly")
                             .foregroundColor(.white)
                             .font(.system(size: 15))
                         Spacer()
                 }
                 if(stopBox){
                     HStack{
                       Text("   ")
                         Button(action: {
                             stopForeToggle()
                         }) {
                             Image(systemName: stopForeBox ? "checkmark.square" : "square")
                                 .padding(3)
                                 .foregroundColor(.white)
                         }
                         Text("fore")
                             .font(.system(size: 15))
                             .foregroundColor(.white)
                             
                         Button(action: {
                             stopBackToggle()
                         }) {
                         Image(systemName: stopBackBox ? "checkmark.square" : "square")
                             .padding(3)
                             .foregroundColor(.white)
                         }
                         Text("back")
                             .font(.system(size: 15))
                             .foregroundColor(.white)
                         
                         Text("direction to hear")
                             .font(.system(size: 15))
                             .foregroundColor(.white)
                     }

             }
         }

     }
     
     
     func renderBottomBtn()->some View{
         return HStack{
                 
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
     }
     
     //=============================================================================
     
     func  strokeForeToggle(){
         strokeForeBox = !strokeForeBox
         saveSettings(name: "strokeFore", value: strokeForeBox ? "true" : "false")
      }
     
     func  strokeBackToggle(){
         strokeBackBox = !strokeBackBox
         saveSettings(name: "strokeBack", value: strokeBackBox ? "true" : "false")
      }
     
     func  straightLeftToggle(){
         straightLeftBox = !straightLeftBox
         saveSettings(name: "straightLeft", value: straightLeftBox ? "true" : "false")
      }
     
     func  straightRightToggle(){
         straightRightBox = !straightRightBox
         saveSettings(name: "straightRight", value: straightRightBox ? "true" : "false")
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
             case "allMoves":
                 allMovesBox = true
                 break
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
         allMovesBox = false
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
         if(skill == "allMoves"){
             allMovesBox = true
         }else if(skill == "stroke"){
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
         allMovesBox = true
         strokeBox = false
         strokeForeBox = true
         strokeBackBox = false
         straightLeftBox = true
         straightRightBox = true
         stopForeBox = true
         stopBackBox = false
         
         saveSettings(name: "left", value: "false")
         saveSettings(name: "right", value: "true")
         saveSettings(name: "skill", value: "allMoves")
         saveSettings(name: "allMoves", value: "true")
         saveSettings(name: "strokeFore", value: "true")
         saveSettings(name: "strokeBack", value: "false")
         saveSettings(name: "straightLeft", value: "true")
         saveSettings(name: "straightRight", value: "true")
         saveSettings(name: "stopFore", value: "true")
         saveSettings(name: "stopBack", value: "false")
     }

     
     func saveSettings(name:String, value:String){
         UserDefaults.standard.set(value,forKey: name)
     }
}
