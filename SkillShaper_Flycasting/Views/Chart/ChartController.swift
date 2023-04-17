
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
    
    func getDirection(invert:Bool) -> String?{
        if(invert){
            if(dataSources.contains(AccAxis.main)){
                return "fore"
            }else if(dataSources.contains(AccAxis.lateral)){
                return "right"
            }else if(dataSources.contains(AccAxis.vertical)){
                return "up"
            }else{
                return nil
            }
        }else{
            if(dataSources.contains(AccAxis.main)){
                return "back"
            }else if(dataSources.contains(AccAxis.lateral)){
                return "left"
            }else if(dataSources.contains(AccAxis.vertical)){
                return "down"
            }else{
                return nil
            }
        }
    }
    
    func isAxisChangeValid(axis:AccAxis)->Bool{
        return dataSources.count > 1 || dataSources.first != axis
    }
    
    func convertFileName(title:String?)->String{
        if (title != nil){
            var titleSplit = title!.split(separator: ":")
            var name = ""
            if(titleSplit.count < 4){
                name = title!
            }else{
                name = titleSplit[0] + ":" + titleSplit[1] + titleSplit[3]
            }
            return name
        }else{
            return ""
        }
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
            Text(convertFileName(title:strokeManager.loadedFile))
                .foregroundColor(yellow)
                .font(.system(size: 25)
                        .bold())
            HStack{
                Button(action: {
                    if(isAxisChangeValid(axis: .main)){
                        chkStroke = !chkStroke
                        if chkStroke{
                            dataSources.insert(AccAxis.main)
                        }else{
                            dataSources.remove(AccAxis.main)
                        }
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
                    if(isAxisChangeValid(axis: .lateral)){
                        chkSide = !chkSide
                        if chkSide{
                            dataSources.insert(AccAxis.lateral)
                        }else{
                            dataSources.remove(AccAxis.lateral)
                        }
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
                    if(isAxisChangeValid(axis: .vertical)){
                        chkUpDown = !chkUpDown
                        if chkUpDown{
                            dataSources.insert(AccAxis.vertical)
                        }else{
                            dataSources.remove(AccAxis.vertical)
                        }
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
            if(dataSources.count < 2){
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
                            Text(getDirection(invert: false) ?? "")
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
                            Text(getDirection(invert: true) ?? "")
                            .font(.system(size: 15))
                            .foregroundColor(yellow)
                        }
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


