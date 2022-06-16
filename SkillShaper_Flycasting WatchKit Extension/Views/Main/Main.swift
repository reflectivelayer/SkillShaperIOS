//
//  Main.swift
//  Skillshaper SwiftUI WatchKit Extension
//

import SwiftUI

struct Main: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        
        VStack {
            
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Spacer()
            
            Button(action: {
                
                self.viewModel.togglePlaying()
                
            }) {
                
                Text(viewModel.title)
                    .foregroundColor(.white)
                    .bold()
                    .padding([.top, .bottom], 10)
                    .padding([.leading, .trailing], 20)
            }
            .background(viewModel.color)
            .cornerRadius(10)
            
            Spacer()
            if(!viewModel.isPlaying){
                NavigationLink(
                    destination: Settings(
                        viewModel: SettingsViewModel(
                            settingsStore: viewModel.settingsStore
                        )
                    )
                ) {
                    
                    HStack {
                        
                        Spacer()
                        
                        Text("Settings")
                        .foregroundColor(.white)
                        .bold()
                        .padding([.top, .bottom], 10)
                        .padding([.leading, .trailing], 20)
                        
                        Spacer()
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .background(Color.gray)
                .cornerRadius(10)
                
                Text("patent pending")
                    .foregroundColor(.green)
            }
        }
    }
}

struct Main_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Main(viewModel: MainViewModel())
    }
}
