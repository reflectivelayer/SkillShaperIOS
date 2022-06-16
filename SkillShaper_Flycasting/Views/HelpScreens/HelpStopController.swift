//
//  HelpStopController.swift
//  SkillShaper_Flycasting
//
//  Created by user on 6/27/21.
//  Copyright © 2021 skillshaper.us. All rights reserved.
//

import SwiftUI
import AVKit

struct HelpStopController: View {
    
    let greenBtn = Color(red: 76.0/255, green: 84.0/255, blue: 75.0/255)
    private let playerStopStrong = AVPlayer(url:  Bundle.main.url(forResource: "stopstrong", withExtension: "mp4")!)
    private let playerStopWeak = AVPlayer(url:  Bundle.main.url(forResource: "stopweak", withExtension: "mp4")!)
    
    @State var isStrong:Bool = false

        func gotoHelp() {
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: HelpController())
                window.makeKeyAndVisible()
            }
        }
        
        var body: some View {
            
            VStack(alignment: .leading, spacing: 0){
                
                Button(action: {
                    gotoHelp()
                }, label: {
                    Text("< BACK <")
                        .padding(7)
                        .font(.system(size: 16))
                        .background(greenBtn)
                        .foregroundColor(.white)
                })
                
                Text(" ")
                
            if(isStrong){
                stopWeak(isStrong: $isStrong)
            }else{
                stopStrong(isStrong: $isStrong)
            }
        }
    }

    struct AVPlayerControllerRepresented2 : UIViewControllerRepresentable {
        var player : AVPlayer
        
        func makeUIViewController(context: Context) -> AVPlayerViewController {
            let controller = AVPlayerViewController()
            controller.player = player
            controller.showsPlaybackControls = false
            return controller
        }
        
        func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
            
        }
      }

    }

    struct AVPlayerControllerRepresented9 : UIViewControllerRepresentable {
        var player : AVPlayer
        
        func makeUIViewController(context: Context) -> AVPlayerViewController {
            let controller = AVPlayerViewController()
            controller.player = player
            controller.showsPlaybackControls = false
            return controller
        }
        
        func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
            
        }
    }

    struct stopStrong: View {
        let greenBtn = Color(red: 76.0/255, green: 84.0/255, blue: 75.0/255)
        private let playerStrong = AVPlayer(url:  Bundle.main.url(forResource: "stopstrong", withExtension: "mp4")!)
        @Binding var isStrong:Bool

        var body: some View {
            VStack{
                
                Text("Practice: Strong Stop")
                    .font(.title)
                    .foregroundColor(.white)
                    .bold()
                Text(" ")
            
            VStack{
                Text("1. Start your stroke slowly.")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                Text(" ")
                Text("2. Accelerate smoothly to a strong stop.")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                Text(" ")
                Text("3. Listen to the sound you made.")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                Text(" ")
                Text("4. Practice until you do it without thinking ")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                Text(" and it sounds right every time. ")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
            }
                
                VStack{
                    AVPlayerControllerRepresented(player: playerStrong)
                        .onAppear {
                        playerStrong.play()
                        }
                    }
                
                HStack {
                    
                        Button(action: {
                            playerStrong.seek(to: CMTime.zero)
                            playerStrong.play()
                        }) {
                            Text("Repeat")
                            .padding(10)
                            .background(greenBtn)
                            .foregroundColor(.white)
                        }
                    
                        Button(action: {
                            isStrong = true
                        }) {
                        Text("Weak")
                            .padding(5)
                            .font(.system(size: 21))
                            .background(greenBtn)
                            .foregroundColor(.white)
                        }
                    }
                }
            }
        }

    struct stopWeak: View {
        let greenBtn = Color(red: 76.0/255, green: 84.0/255, blue: 75.0/255)
        private let playerWeak = AVPlayer(url:  Bundle.main.url(forResource: "stopweak", withExtension: "mp4")!)
        @Binding var isStrong:Bool
        
        var body: some View {
            VStack{
                
                Text("Practice: Weak Stop")
                    .font(.title)
                    .foregroundColor(.white)
                    .bold()
                Text(" ")
            
            VStack{
                Text("1. Start your stroke slowly.")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                Text(" ")
                Text("2. Accelerate smoothly to a weak stop.")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                Text(" ")
                Text("3. Listen to the sound you made.")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                Text(" ")
                Text("4. Practice until you do it without thinking ")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                Text(" and it sounds right every time. ")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
            }
                
                VStack{
                    AVPlayerControllerRepresented(player: playerWeak)
                        .onAppear {
                        playerWeak.play()
                        }
                    }
                
                HStack {
  
                        Button(action: {  // weak
                            print("weak")
                            playerWeak.seek(to: CMTime.zero)
                            playerWeak.play()
                        }) {
                            Text("Repeat")
                            .padding(10)
                            .background(greenBtn)
                            .foregroundColor(.white)
                        }
                    
                         Button(action: {  // weak
                             print("weak stop")
                             isStrong = false
                         }) {
                         Text("Strong")
                             .padding(5)
                             .font(.system(size: 21))
                             .background(greenBtn)
                             .foregroundColor(.white)
                         }
                    
                    }
                }
            }
        }
