//
//  Stroke.swift
//  SkillShaper_Flycasting
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import SwiftUI
import AVFoundation

struct Stroke: View {
    
    @State var viewModel = StrokeViewModel()
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 8) {
                
                Text(viewModel.title)
                    .font(.system(size: 20))
                    .bold()
                    .padding(.top, 16)
                
                Text(viewModel.rules)
                
                Video(player: viewModel.player)
                    .cornerRadius(10)
                    .frame(width: nil, height: 200)
                    .shadow(radius: 5)
                    .padding()
                
                Text(viewModel.subtitle)
                    .font(.system(size: 20))
                    .bold()
                
                HStack {
                    
                    Button(action: {
                        
                        self.viewModel.player.seek(to: .zero)
                        self.viewModel.player.play()
                        
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
                    
                    Button(action: {
                        
                        self.viewModel.isStrokeOneWay.toggle()
                        
                    }, label: {
                        
                        Text(viewModel.buttonTitle)
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

struct Stroke_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Stroke()
    }
}
