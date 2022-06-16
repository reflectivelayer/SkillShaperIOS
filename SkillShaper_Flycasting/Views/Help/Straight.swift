//
//  Straight.swift
//  SkillShaper_Flycasting
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import SwiftUI
import AVFoundation

struct Straight: View {
    
    private let player: AVPlayer
    
    init() {
        
        self.player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "straightline", ofType: "mp4")!))
    }
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 8) {
                
                Text("Practice Casting: Straight Stroke")
                    .font(.system(size: 20))
                    .bold()
                    .padding(.top, 16)
                
                Text("1. Keep your rod stroking in a straight line\n2. With no veering to right or left\n3. You will hear it when it swerves off its line\n4. Practice until you do it without thinking and it sounds right every time")
                
                Video(player: player)
                    .cornerRadius(10)
                    .frame(width: nil, height: 200)
                    .shadow(radius: 5)
                    .padding()
                
                Text("Keep straight")
                    .font(.system(size: 20))
                    .bold()
                
                HStack {
                    
                    Button(action: {
                        
                        self.player.seek(to: .zero)
                        self.player.play()
                        
                    }, label: {
                        
                        Text("Play")
                            .bold()
                            .foregroundColor(.white)
                            .padding([.top, .bottom], 8)
                            .padding([.leading, .trailing], 16)
                            .frame(width: 100)
                    })
                    .background(Color.green)
                    .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

struct Straight_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Straight()
    }
}
