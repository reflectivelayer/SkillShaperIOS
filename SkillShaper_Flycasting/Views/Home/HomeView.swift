
//
//  Dashboard.swift
//  SkillShaper_Flycasting
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
// Build 28

import SwiftUI
import UIKit
import CoreMotion

var accData = [CMAttitude]()
var index = 0
var strokeManager:StrokeManager = StrokeManager()
var remoteAccelerometer = false

struct HomeView: View {
    @ObservedObject var viewModel: ConfigViewModel
    @StateObject var motion: MotionManager
    let queue = OperationQueue()
    let greenBtn = Color(red: 76.0/255, green: 84.0/255, blue: 75.0/255)
    let timeLength = 13
    @State var startBtnVisible = true
    @State var stopBtnVisible = false

    @State var isLogging = false
    @State var accAxis = AccAxis.main
    @State var accMainStrength:Double = 0
    @State var accLateralStrength:Double = 0
    @State var timeRemaining = 0
    @State var timerActive = false
    @State var dataBtnEnabled = true
    @State var watchDataEnabled = false
    @State var remoteAcc = false
    
    @State var isPresenting = false
    
    ///
    func dataToggle(){
        ("data btn", isOn: $dataBtnEnabled)
    }

    func  toggle(){
        remoteAccelerometer = !remoteAccelerometer
        remoteAcc = remoteAccelerometer
    }

    func gotoSettings() {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: SettingsContoller())
            window.makeKeyAndVisible()
        }
    }

    func gotoHelp() {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: HelpController())
            window.makeKeyAndVisible()
        }
    }

    func gotoDataFiles() {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController  = UIHostingController(rootView: DataFilesView())
            window.makeKeyAndVisible()
        }
    }
    
    func getSkillHearName()->String{
        let skill = UserDefaults.standard.string(forKey: "skill") ?? "stroke"
        var hear = ""
        var fore:String?
        var back:String?
        switch skill {
            case "stroke":
                fore = UserDefaults.standard.string(forKey: "strokeFore")
                back = UserDefaults.standard.string(forKey: "strokeBack")
                break
            case "stop":
                fore = UserDefaults.standard.string(forKey: "stopFore")
                back = UserDefaults.standard.string(forKey: "stopBack")
                break
        default:
            break
        }
        
        if(fore == nil || back == nil){
            hear = "foward cast"
        }else if(fore == "true" && back == "true"){
            hear = "Both ways"
        }else if(fore == "true" && back == "false"){
            hear = "foward cast"
        }else if(fore == "false" && back == "true"){
            hear = "back cast"
        }
        return skill.uppercased() + " " + hear
        
    }
    
    func stopLogging() {
        startBtnVisible = true
        stopBtnVisible = false
        dataBtnEnabled = true
        isLogging = false
        strokeManager.stop()
        strokeManager.saveData()
    }

    var body: some View {
        NavigationView{
        VStack{

            Logo()

            VStack{
            
                HStack {

                    
                    Button(action: {
                        if(!remoteAcc){
                            startBtnVisible = false
                            stopBtnVisible = true
                            dataBtnEnabled = false
                            isLogging = true
                            motion.start()
                            strokeManager.start()
                        }
                    }) {
                    Text(" ")
                        .padding(.top, 61)
                    if startBtnVisible && !remoteAcc{
                        Text("START")
                            .padding(5)
                            .font(.system(size: 21))
                            .background(greenBtn)
                            .foregroundColor(.green)
                    }else{
                        Text("START")
                            .padding(5)
                            .font(.system(size: 21))
                            .background(greenBtn)
                            .foregroundColor(.green)
                            .hidden()
                    }
                }
                    VStack(alignment: .leading){
                        Button(action: {
                            toggle()
                        }) {

                            HStack{
                                Image(systemName: remoteAcc ? "checkmark.square" : "square")
                                    .padding(3)
                                    .foregroundColor(.white)
                                Text("Remote sensor")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                            }
                        }
                        if(remoteAccelerometer){
                            Text("\(viewModel.skillTitle.uppercased()) \(viewModel.hearsTitle)")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                        }else{
                            Text(getSkillHearName())
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                        }
                    }
                    
                    Button(action: {
                        stopLogging()
                        motion.stop()
                    }) {
                    Text(" ")
                        .padding(.top, 61)
                    if stopBtnVisible {
                        Text("STOP")
                            .padding(5)
                            .font(.system(size: 21))
                            .background(greenBtn)
                            .foregroundColor(.red)
                    }else{
                        Text("STOP")
                            .padding(5)
                            .font(.system(size: 21))
                            .background(greenBtn)
                            .foregroundColor(.red).hidden()
                            .disabled(true)
                    }
                    Text("  ")
                    }
                              // if stop
                }

                if isLogging{
                    AccStrengthView(motion: motion)
                }

        }
        .onAppear {
                timeRemaining = timeLength
                print("ON APPEAR")
                strokeManager.setMotionManager(motionManager: motion)
                strokeManager.stop()
            accMainStrength = motion.acc.x
            accLateralStrength = motion.acc.y
            remoteAcc = remoteAccelerometer

            }.onDisappear {
                motion.stop()
            }//.onappear

                Spacer()

                HStack {
                    
                Button("SETTINGS") {
                    gotoSettings()
                }
                .padding(10)
                .background(greenBtn)
                .foregroundColor(remoteAcc ? .gray : .white)
                .disabled(remoteAcc)
                NavigationLink(
                    destination: DataFilesView().navigationBarBackButtonHidden(true),
                    label: {
                        Text("DATA")
                    })
                .padding(10)
                .background(greenBtn)
                .foregroundColor((remoteAcc && watchDataEnabled) || (!remoteAcc && dataBtnEnabled) ? .white : .gray)
                .disabled((remoteAcc && !watchDataEnabled) || (!remoteAcc && !dataBtnEnabled))
                .onChange(of: viewModel.isPlayingTitle, perform: { isPlaying in
                    if(remoteAcc){
                        dataBtnEnabled = isPlaying != "Running"
                    }
                })
                    
                    
                Button("HELP") {
                   print("Help")
                   gotoHelp()
                }
                .padding(10)
                .background(greenBtn)
                .foregroundColor(.white)

                Button("QUIT") {
                    print("Quit")
                    exit(-1)
                }
                .padding(10)
                .background(greenBtn)
                .foregroundColor(.white)
                    
               }

             } .navigationBarTitle("")
              .navigationBarHidden(true)
              .onReceive(viewModel.$isPlaying, perform: { status in
                 if(remoteAcc){
                     if(!status){
                         watchDataEnabled = true
                     }else{
                         watchDataEnabled = false
                     }
                 }
             });
                    Text(" ")
         }
    }
}

