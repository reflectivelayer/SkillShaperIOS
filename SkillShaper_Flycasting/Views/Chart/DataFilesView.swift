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
    @State private var showTargetView = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showShareSheet = false
    @State private var showingAlert = false
    
    func geFileList(){
        selectedItems.removeAll()
        fileList = strokeManager.getFileList()
        fileList = fileList.sorted(by: { $0.lastPathComponent > $1.lastPathComponent })
    }
    
    func goBack() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.763) {
            presentationMode.wrappedValue.dismiss()
      }
    }
    

    
    var body: some View {
        VStack{
            Text("Data Files")
                .foregroundColor(yellow)
                .font(.system(size: 30)
                        .bold())
                       
            List {
                ForEach(fileList, id: \.self) { url in
                    var isSelected = selectedItems.contains(url.lastPathComponent)
                    renderFileEntry(title: url.lastPathComponent).listRowBackground(isSelected ? Color(red:0.9,green:0.9,blue:0.9) : Color.white)
                }.listRowBackground(Color.white)
            }
            
            HStack{
                //NavigationLink(
                  //  destination: ChartController().navigationBarBackButtonHidden(true).onAppear(perform: {
                    //    onChartTapped()
                   // })
                NavigationLink(destination: ChartController(), isActive: $showTargetView) { EmptyView() }

                Button(action: {
                    onChartTapped()
                    showTargetView = true
                }
                    ,
                    label: {
                        Text("CHART")
                            .padding(7)
                            .font(.system(size: 13))
                            .background(greenBtn)
                            .foregroundColor(btnEnableChart ? .white : .gray)
                    }).disabled(!btnEnableChart)

    
                Button(action: {
                    onDeleteTapped()
                }, label: {
                    Text("DELETE")
                        .padding(7)
                        .font(.system(size: 13))
                        .background(greenBtn)
                        .foregroundColor(btnEnableDelete ? .white : .gray)
                }).disabled(!btnEnableDelete)
                   
                Button(action: {
                    onSendTapped()
                }, label: {
                    Text("SEND")
                        .padding(7)
                        .font(.system(size: 13))
                        .background(greenBtn)
                        .foregroundColor(btnEnableSend ? .white : .gray)
                }).disabled(!btnEnableSend)
                    
                Button(action: {
                    showingAlert = true
                }, label: {
                    Text("ERASE ALL")
                        .padding(7)
                        .font(.system(size: 13))
                        .background(greenBtn)
                        .foregroundColor(fileList.count>0 ? .white : .gray)
                }).disabled(fileList.count==0)
                .alert(isPresented:$showingAlert) {
                            Alert(
                                title: Text("Erase all session data records?"),
                                message: Text("You will lose them permanently"),
                                primaryButton: .destructive(Text("Delete")) {
                                    onEraseAllTapped()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                
                
                
                
                
                
                
                Button(action: {
                    goBack()
                }, label: {
                    Text("<Back")
                        .padding(7)
                        .font(.system(size: 12))
                        .background(greenBtn)
                        .foregroundColor(.white)
                })
            }
        }.navigationBarTitle("")
        .navigationBarHidden(true)
        .onAppear {
            UITableView.appearance().backgroundColor = .white
            geFileList()
            updateButtons()
        } .sheet(isPresented: $showShareSheet) {
            if selectedItems.first != nil {
                let data = strokeManager.getDataFromFile(fileName: selectedItems.first!)
                ShareSheet(subject:selectedItems.first!, activityItems:[data])
            }
        }
     }
    
    
    //================================= Logic
    
    func renderFileEntry(title:String)->some View{
        
        return HStack{
            Text(convertFileName(title: title))
                .font(.system(size: 17))
                .bold()
                .foregroundColor(.black)
            Spacer()
            Button(action: {
                onFileItemTapped(title:title)
            }) {
            Image(systemName: selectedItems.contains(title) ? "checkmark.square" : "square")
                .padding(3)
                .foregroundColor(.black)
            }
        }
    }
    
    func convertFileName(title:String)->String{
        var titleSplit = title.split(separator: ":")
        var name = ""
        if(titleSplit.count < 4){
            name = title
        }else{
           name = titleSplit[0] + ":" + titleSplit[1] + titleSplit[3]
        }
        return name
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
            strokeManager.loadDataFromFile(fileName: selectedItems.first ?? "")
        }
    }
    
    func onDeleteTapped(){
        var toRemove:[URL] = []
        for item in selectedItems {
            strokeManager.deleteDataFile(fileName: item)
            fileList.forEach { url in
                if url.lastPathComponent == item{
                    toRemove.append(url)
                }
            }
        }
        fileList = Array(Set(fileList).subtracting(toRemove))
        geFileList()
    }
    
    func onSendTapped(){
        showShareSheet = true
    }
    
    func onEraseAllTapped(){
        for item in fileList {
            strokeManager.deleteDataFile(fileName: item.lastPathComponent)
        }
        fileList.removeAll()
    }
    
    func updateButtons(){
        var count = selectedItems.count
        if count == 0{
            btnEnableChart = false
            btnEnableDelete = false
            btnEnableSend = false
        }else if count == 1{
            btnEnableChart = true
            btnEnableDelete = true
            btnEnableSend = true
        }else{
            btnEnableChart = false
            btnEnableDelete = true
            btnEnableSend = false
        }
    }
}


struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    let subject: String
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        controller.setValue(subject, forKey: "subject")
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}



