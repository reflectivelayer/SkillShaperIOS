
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
    let yellow = Color(UIColor(hexaString: "#CDDC39"))
    @State var offset = CGSize.zero
    @State var remoteBoxClicked1 = false
    @State var remoteBoxClicked2 = false
    @State var drawBtnClicked = true //TODO Make FALSE
    @State var dataSources:Set = [AccAxis.main]
    @State var fillPositive = false
    @State var fillNegative = false
    @State var chkStroke = true
    @State var chkSide = false
    @State var chkUpDown = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

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
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing:0){
            Text(" ")
        
        ZStack {
            Color.black
            
        VStack{
            Text("Axis Accelerations")
                .foregroundColor(yellow)
                .font(.system(size: 30)
                        .bold())
            
            HStack{
                Button(action: {
                    chkStroke = !chkStroke
                    if chkStroke{
                        dataSources.insert(AccAxis.main)
                    }else{
                        dataSources.remove(AccAxis.main)
                    }
                }) {
                    HStack{
                        Image(systemName: !chkStroke ? "square" : "checkmark.square")
                            .padding(3)
                            .foregroundColor(.green)
                        VStack{
                            Text("Stroke")
                            .font(.system(size: 15))
                            .foregroundColor(yellow)
                        }
                    }
                }
                Button(action: {
                    chkSide = !chkSide
                    if chkSide{
                        dataSources.insert(AccAxis.lateral)
                    }else{
                        dataSources.remove(AccAxis.lateral)
                    }
                }) {
                    HStack{
                        Image(systemName: !chkSide ? "square" : "checkmark.square")
                            .padding(3)
                            .foregroundColor(.green)
                        VStack{
                            Text("Side")
                            .font(.system(size: 15))
                            .foregroundColor(yellow)
                        }
                    }
                }
                Button(action: {
                    chkUpDown = !chkUpDown
                    if chkUpDown{
                        dataSources.insert(AccAxis.vertical)
                    }else{
                        dataSources.remove(AccAxis.vertical)
                    }
                }) {
                    HStack{
                        Image(systemName: !chkUpDown ? "square" : "checkmark.square")
                            .padding(3)
                            .foregroundColor(.green)
                        VStack{
                            Text("UpDown")
                            .font(.system(size: 15))
                            .foregroundColor(yellow)
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
                    ChartGrid(dataSources: $dataSources,fillPositive: $fillPositive,fillNegative: $fillNegative, offset: $offset)
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
                Text("Highlight acceleraions")
                    .foregroundColor(yellow)
                    .font(.system(size: 15))
                Button(action: {
                    toggle1()
                    fillPositive = remoteBoxClicked1
                }) {
                    HStack{
                      Image(systemName: !remoteBoxClicked1 ? "square" : "checkmark.square")
                            .padding(3)
                            .foregroundColor(.green)
                        VStack{
                            Text(dataSources.contains(AccAxis.main) ? "fore" : "left")
                            .font(.system(size: 15))
                            .foregroundColor(yellow)
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
                            Text(dataSources.contains(AccAxis.main) ? "back" : "right")
                            .font(.system(size: 15))
                            .foregroundColor(yellow)
                        }
                    }
                }
            }
            
            HStack{
                Text("Drag the graph to see all of it")
                Spacer()
                Button(action: {
                    goHome()
                }, label: {
                    Text("<BACK")
                        .padding(7)
                        .font(.system(size: 14))
                        .background(greenBtn)
                        .foregroundColor(.white)
                })
            }
        }
     }
    }.navigationBarTitle("")
    .navigationBarHidden(true)
  }
}


