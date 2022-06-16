
//
//  ChartController.swift
//  SkillShaper_Flycasting
//
//  Created by user on 6/26/21.
//  Copyright © 2021 skillshaper.us. All rights reserved.
//

import SwiftUI

struct ChartController: View {
    
    let greenBtn = Color(red: 76.0/255, green: 84.0/255, blue: 75.0/255)
    @State var offset = CGSize.zero
    @State var remoteBoxClicked1 = false
    @State var remoteBoxClicked2 = false
    @State var drawBtnClicked = true //TODO Make FALSE
    @State var radioBtnSideways = false
    @State var dataSource = AccAxis.main
    @State var fillPositive = false
    @State var fillNegative = false
    func  toggle1(){
        remoteBoxClicked1 = !remoteBoxClicked1
     }
    
    func  toggle2(){
        remoteBoxClicked2 = !remoteBoxClicked2
     }
    
    func toggle8(){
        drawBtnClicked = !drawBtnClicked
    }
    
    func goHome() {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: HomeView(viewModel:viewModel.configViewModel, motion: MotionManager()))
            window.makeKeyAndVisible()
        }
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing:0){
            Text(" ")
        
        ZStack {
            Color.black
            
        VStack{
            HStack{
                Text("Show acceleraions on")
                    .foregroundColor(.green)
                    .font(.system(size: 15))
                Button(action: {
                    radioBtnSideways = false
                    print("cast axis btn")
                    dataSource = AccAxis.main
                }) {
                    HStack{
                      Image(systemName: radioBtnSideways ? "circle" : "largecircle.fill.circle")
                            .padding(3)
                            .foregroundColor(.green)
                        VStack{
                        Text("Cast axis")
                            .font(.system(size: 15))
                            .foregroundColor(.green)
                        }
                    }
                }
                Button(action: {
                    radioBtnSideways = true
                    print("sideways radio btn")
                    dataSource = AccAxis.lateral
                }) {
                    HStack{
                        Image(systemName: radioBtnSideways ? "largecircle.fill.circle" : "circle")
                            .padding(3)
                            .foregroundColor(.green)
                        VStack{
                        Text("Sideways")
                            .font(.system(size: 15))
                            .foregroundColor(.green)
                        }
                    }
                }
            }

            HStack{
                Text("Highlight acceleraions")
                    .foregroundColor(.green)
                    .font(.system(size: 15))
                Button(action: {
                    toggle1()
                    print("forward check box")
                    fillPositive = remoteBoxClicked1
                }) {
                    HStack{
                      Image(systemName: !remoteBoxClicked1 ? "square" : "checkmark.square")
                            .padding(3)
                            .foregroundColor(.green)
                        VStack{
                        Text("Forward")
                            .font(.system(size: 15))
                            .foregroundColor(.green)
                        }
                    }
                }
                Button(action: {
                    toggle2()
                    print("backwardcheck box")
                    fillNegative = remoteBoxClicked2
                }) {
                    HStack{
                        Image(systemName: !remoteBoxClicked2 ? "square" : "checkmark.square")
                            .padding(3)
                            .foregroundColor(.green)
                        VStack{
                        Text("Backward")
                            .font(.system(size: 15))
                            .foregroundColor(.green)
                        }
                    }
                }
            }
            
            VStack{
                if !drawBtnClicked{
                Image("blankChart")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                } else {
                    ChartGrid(dataSource: $dataSource,fillPositive: $fillPositive,fillNegative: $fillNegative, offset: $offset)
                        .background(Color.white)
                        .gesture(DragGesture().onChanged({ gesture in
                            self.offset = gesture.translation
                            strokeManager.offsetChart(offset: Int(self.offset.width))
                        }).onEnded({ gesture in
                            self.offset = gesture.predictedEndTranslation
                            strokeManager.updateOffset()
                        })
                    )
                }
            
            }
            HStack{
                Text("Drag the graph to see all of it")
                Spacer()
                Button(action: {
                    goHome()
                }, label: {
                    Text("< BACK <")
                        .padding(7)
                        .font(.system(size: 16))
                        .background(greenBtn)
                        .foregroundColor(.white)
                })
            }
        }
     }
  }
    }
}


