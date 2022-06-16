//
//  Help.swift
//  SkillShaper_Flycasting
//
//  Copyright © 2020 skillshaper.us. All rights reserved.
//

import SwiftUI

struct Help: View {
    
    @State var skillView: AnyView = AnyView(Stroke())
    @State var showHelpSkillView: Bool = false
    
    var body: some View {
        
        ScrollView {
            
            
            
            VStack(spacing: 8) {
                
                Text("About")
                    .font(.title)
                    .bold()
                
                Text("SkillShaper Flycast v.1.9.0\nPatent pending Langbourne Rust Research, Inc.")
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
            
            VStack(spacing: 8) {

                Text("Shaping Skills")
                    .font(.title)
                    .bold()

                Text("Practice casting strokes.\nCorrect bad habits.\nBuild good muscle memory.")
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding([.leading, .trailing, .bottom])
            
            HStack {
                
                VStack(spacing: 8) {

                    HStack {

                        Text("In-Hand casting")
                            .font(.system(size: 20))
                            .bold()

                        Spacer()
                    }
                    .padding(.top)

                    HStack {

                        Text("Hold it like this:\nPress [Start] and pantomime a cast.\nTap [Stop] to stop.")
                            .fixedSize(horizontal: false, vertical: true)

                        Spacer()
                    }
                    .padding(.leading)
                }
                
                Image("applewatch-aircast-grid")
            }
            .padding([.leading, .trailing, .bottom])
            
            HStack {

                Text("On-Rod casting")
                    .font(.system(size: 20))
                    .bold()

                Spacer()
            }
            .padding([.leading, .trailing])
            
            HStack {
                
                VStack(spacing: 8) {

                    HStack {

                        Text("In-Line mount -")

                        Spacer()
                    }
                    .padding(.leading)

                    HStack {

                        Text("Lay straps along the grip.\nSecure with rubber band.\nGrasp with thumb on top.")
                            .fixedSize(horizontal: false, vertical: true)

                        Spacer()
                    }
                    .padding(.leading, 32)
                }
                
                Image("inlinemount")
            }
            .padding([.leading, .trailing, .bottom])
            
            HStack {
                
                VStack(spacing: 8) {

                    HStack {

                        Text("Sideways mount -")

                        Spacer()
                    }
                    .padding(.leading)

                    HStack {

                        VStack(alignment: .leading) {

                            Text("Strap around grip.\nThumb between watch and grip.")
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        Spacer()
                    }
                    .padding(.leading, 32)
                }
                
                Image("sidewaysmount")
            }
            .padding([.leading, .trailing, .bottom])
            
            VStack(spacing: 8) {

                HStack {

                    Text("Work on different skills")
                        .font(.system(size: 20))
                        .bold()

                    Spacer()
                }
                .padding(.top)

                HStack {

                    Text("Smooth acceleration.\nMaking crisp stops.\nKepping your strokes straight.")
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()
                }
                .padding(.leading)
            }
            .padding([.leading, .trailing, .bottom])
            
            VStack(spacing: 16) {

                Text("How to Practice")
                    .font(.title)
                    .bold()
                    .padding(.top)

                HStack {

                    Button(action: {

                        self.skillView = AnyView(Stroke())
                        self.showHelpSkillView.toggle()

                    }, label: {

                        Text("Stroke")
                            .bold()
                            .foregroundColor(.white)
                            .padding([.top, .bottom], 8)
                            .padding([.leading, .trailing], 16)
                            .frame(width: 100)
                    })
                        .background(Color.green)
                        .cornerRadius(10)

                    Button(action: {

                        self.skillView = AnyView(Stop())
                        self.showHelpSkillView.toggle()

                    }, label: {

                        Text("Stop")
                            .bold()
                            .foregroundColor(.white)
                            .padding([.top, .bottom], 8)
                            .padding([.leading, .trailing], 16)
                            .frame(width: 100)
                    })
                        .background(Color.green)
                        .cornerRadius(10)

                    Button(action: {

                        self.skillView = AnyView(Straight())
                        self.showHelpSkillView.toggle()

                    }, label: {

                        Text("Straight")
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
        .sheet(isPresented: $showHelpSkillView) {
            
            self.skillView
        }
    }
}

struct Help_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Help()
    }
}
