//
//  HelpStrokeController.swift
//  SkillShaper_Flycasting
//
//  Created by user on 6/27/21.
//  Copyright © 2021 skillshaper.us. All rights reserved.
//

import SwiftUI
import AVKit

struct HelpStrokeController: View {
    let greenBtn = Color(red: 76.0/255, green: 84.0/255, blue: 75.0/255)
    @State var is2Way:Bool = false

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
            
        if(is2Way){
            Stroke2Way(is2Way: $is2Way)
        }else{
            Stroke1Way(is2Way: $is2Way)
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

struct AVPlayerControllerRepresented : UIViewControllerRepresentable {
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

struct Stroke1Way: View {
    let greenBtn = Color(red: 76.0/255, green: 84.0/255, blue: 75.0/255)
    private let playerStroke = AVPlayer(url:  Bundle.main.url(forResource: "strokefore", withExtension: "mp4")!)
    @Binding var is2Way:Bool

    var body: some View {
        VStack{
            
            Text("Practice Casting: 1-Way")
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
                AVPlayerControllerRepresented(player: playerStroke)
                    .onAppear {
                    playerStroke.play()
                    }
                }
            
            HStack {
                
                    Button(action: {  // repeat 1-way
                        playerStroke.seek(to: CMTime.zero)
                        playerStroke.play()
                    }) {
                        Text("Repeat")
                        .padding(10)
                        .background(greenBtn)
                        .foregroundColor(.white)
                    }
                
                    Button(action: {  // 1-way
                        is2Way = true
                    }) {
                    Text("2-Way")
                        .padding(5)
                        .font(.system(size: 21))
                        .background(greenBtn)
                        .foregroundColor(.white)
                    }
                    
                }
            }
        }
    }

struct Stroke2Way: View {
    let greenBtn = Color(red: 76.0/255, green: 84.0/255, blue: 75.0/255)
    private let playerStroke = AVPlayer(url:  Bundle.main.url(forResource: "strokebothways", withExtension: "mp4")!)
    @Binding var is2Way:Bool
    
    var body: some View {
        VStack{
            
            Text("Practice Casting: 2-Way")
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
                AVPlayerControllerRepresented(player: playerStroke)
                    .onAppear {
                    playerStroke.play()
                    }
                }
            
            HStack {
               
                    Button(action: {  // repeat 2-way
                        print("2-way")
                        playerStroke.seek(to: CMTime.zero)
                        playerStroke.play()
                    }) {
                        Text("Repeat")
                        .padding(10)
                        .background(greenBtn)
                        .foregroundColor(.white)
                    }
                
                    Button(action: {  // 2-way
                        print("2-way")
                        is2Way = false
                    }) {
                    Text("1-Way")
                        .padding(5)
                        .font(.system(size: 21))
                        .background(greenBtn)
                        .foregroundColor(.white)
                    }
                
                }
            }
        }
    }
