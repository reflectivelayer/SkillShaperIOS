//
//  HelpStraightController.swift
//  SkillShaper_Flycasting
//
//  Created by user on 6/27/21.
//  Copyright © 2021 skillshaper.us. All rights reserved.
//

import SwiftUI
import AVKit

struct HelpStraightController: View {
    
    let greenBtn = Color(red: 76.0/255, green: 84.0/255, blue: 75.0/255)
    private let playerStraightLine = AVPlayer(url:  Bundle.main.url(forResource: "straightline", withExtension: "mp4")!)
    
    @State var remoteBoxClicked1 = false
    @State var remoteBoxClicked2 = false
    @State var radioBtnClicked1 = true
    @State var radioBtnClicked2 = true
    @State var oneBtnVisible = true
    @State var twoBtnVisible = false
    
    func gotoHelp() {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: HelpController())
            window.makeKeyAndVisible()
        }
    }

    func  toggle1(){
        remoteBoxClicked1 = !remoteBoxClicked1
     }
    func  toggle2(){
        remoteBoxClicked2 = !remoteBoxClicked2
     }
    func  toggle6(){
        radioBtnClicked1 = !radioBtnClicked1
     }
    func  toggle7(){
        radioBtnClicked2 = !radioBtnClicked2
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
            
        ZStack {
            Color.black
            
            VStack{
                
                Text("Practice Casting: Straight Stroke")
                    .font(.title)
                    .foregroundColor(.white)
                Text(" ")
            
                VStack{
                    Text("1. Keep your rod stroking in a straight line.")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    Text(" ")
                    Text("2. With no veering to the right orleft.")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    Text(" ")
                    Text("3. You will hear it when it swerves off its line.")
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
                    
                    AVPlayerControllerRepresented2(player: playerStraightLine)
                        .onAppear {
                            playerStraightLine.play()
                        }
                }
                
            HStack{
                Button(action: {
                    print("repeat button")
                    playerStraightLine.seek(to: CMTime.zero)
                    playerStraightLine.play()
                }) {
                    Text("Repeat")
                    .padding(10)
                    .background(greenBtn)
                    .foregroundColor(.white)
                }
               }
            Text(" ")
                
            }
         }
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
