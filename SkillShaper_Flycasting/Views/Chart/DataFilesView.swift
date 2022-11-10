//
//  DataFilesView.swift
//  SkillShaper_Flycasting
//
//  Created by PUA on 11/9/22.
//  Copyright © 2022 skillshaper.us. All rights reserved.
//

import SwiftUI

struct DataFilesView: View {
    
    let greenBtn = Color(red: 76.0/255, green: 84.0/255, blue: 75.0/255)
    let yellow = Color(UIColor(hexaString: "#CDDC39"))
    @State var offset = CGSize.zero
    @State var remoteBoxClicked1 = false
    @State var remoteBoxClicked2 = false
    @State var drawBtnClicked = true //TODO Make FALSE
    @State var dataSource = AccAxis.main
    @State var fillPositive = false
    @State var fillNegative = false
    @State var chkStroke = true
    @State var chkSide = false
    @State var chkUpDown = false
    @State var selectedItems:Set<String> = Set<String>()
    @State var fileList:[URL] = []
    @State var btnEnableChart = false
    @State var btnEnableDelete = false
    @State var btnEnableSend = false
    @State var btnEnableDeleteAll = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    func geFileList(){
        selectedItems.removeAll()
        fileList = strokeManager.getFileList()
    }
    
    func goHome() {
        /*
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: HomeView(viewModel:viewModel.configViewModel, motion: MotionManager()))
            window.makeKeyAndVisible()
        }
         */
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack{
            Text("Data Files")
                .foregroundColor(yellow)
                .font(.system(size: 30)
                        .bold())
                       
            List {
                ForEach(fileList, id: \.self) { url in
                    renderFileEntry(title: url.lastPathComponent)
                }.listRowBackground(Color.white)
            }
            
            HStack{
                Button(action: {
                    onChartTapped()
                }, label: {
                    Text("CHART")
                        .padding(7)
                        .font(.system(size: 14))
                        .background(greenBtn)
                        .foregroundColor(btnEnableChart ? .white : .gray)
                }).disabled(!btnEnableChart)
                    
                Button(action: {
                    goHome()
                }, label: {
                    Text("DELETE")
                        .padding(7)
                        .font(.system(size: 14))
                        .background(greenBtn)
                        .foregroundColor(btnEnableDelete ? .white : .gray)
                }).disabled(!btnEnableDelete)
                   
                Button(action: {
                    goHome()
                }, label: {
                    Text("SEND")
                        .padding(7)
                        .font(.system(size: 14))
                        .background(greenBtn)
                        .foregroundColor(btnEnableSend ? .white : .gray)
                }).disabled(!btnEnableSend)
                    
                Button(action: {
                    goHome()
                }, label: {
                    Text("ERASE ALL")
                        .padding(7)
                        .font(.system(size: 14))
                        .background(greenBtn)
                        .foregroundColor(btnEnableDeleteAll ? .white : .gray)
                }).disabled(!btnEnableDeleteAll)
            
                Button(action: {
                    goHome()
                }, label: {
                    Text("<Back")
                        .padding(7)
                        .font(.system(size: 14))
                        .background(greenBtn)
                        .foregroundColor(.white)
                })
            }
        }.navigationBarTitle("")
        .navigationBarHidden(true)
        .onAppear {
            UITableView.appearance().backgroundColor = .white
            geFileList()
        }
     }
    
    
    //================================= Logic
    
    func renderFileEntry(title:String)->some View{
        return HStack{
            Text(title)
                .font(.system(size: 17))
                .bold()
                .foregroundColor(.black)
            Button(action: {
                onFileItemTapped(title:title)
            }) {
            Image(systemName: selectedItems.contains(title) ? "checkmark.square" : "square")
                .padding(3)
                .foregroundColor(.black)
            }
        }
    }
    
    
    func onFileItemTapped(title:String){
        if selectedItems.contains(title){
            selectedItems.remove(title)
        }else{
            selectedItems.insert(title)
        }
        updateButtons()
    }
    
    func onChartTapped(){
        if !selectedItems.isEmpty{
            strokeManager.loadDataFromFile(path: selectedItems.first ?? "")
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: ChartController())
                window.makeKeyAndVisible()
            }

        }
    }
    
    func updateButtons(){
        var count = selectedItems.count
        if count == 0{
            btnEnableChart = false
            btnEnableDelete = false
            btnEnableSend = false
            btnEnableDeleteAll = false
        }else if count == 1{
            btnEnableChart = true
            btnEnableDelete = true
            btnEnableSend = true
            btnEnableDeleteAll = true
        }else{
            btnEnableChart = false
            btnEnableDelete = true
            btnEnableSend = false
            btnEnableDeleteAll = true
        }
    }
}




