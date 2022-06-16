
//
//  HelpController.swift
//  SkillShaper_Flycasting
//
//  Created by user on 6/27/21.
//  Copyright © 2021 skillshaper.us. All rights reserved.
//

import SwiftUI

struct HelpController: View {

        let greenBtn = Color(red: 76.0/255, green: 84.0/255, blue: 75.0/255)
        // let blkText = Color(.black)
        let blkText = Color(.white) // not really black text
        @State var isNavigationBarHidden: Bool = true

    func goHome() {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: HomeView(viewModel:viewModel.configViewModel,motion: MotionManager()))
            window.makeKeyAndVisible()
        }
    }

    func go2Stroke() {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: HelpStrokeController())
            window.makeKeyAndVisible()
        }
    }

    func go2Stop() {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: HelpStopController())
            window.makeKeyAndVisible()
        }
    }

    func go2Straight() {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: HelpStraightController())
            window.makeKeyAndVisible()
        }
    }

        var body: some View {

                VStack(alignment: .leading, spacing: 0){
                    Text(" ")

                       ZStack {
                           Color.black

                               .navigationBarTitle("Click To Page Back")
                               .navigationBarHidden(self.isNavigationBarHidden)
                               .onAppear {
                               self.isNavigationBarHidden = true
                               }

                        VStack{

                           VStack{
                               Text("SkillShaper Flycast Pro")
                                   .foregroundColor(blkText)
                               Text("2.0.1 Beta")
                                   .foregroundColor(blkText)
                               Text(" ")
                               Text("Getting Started")
                                   .bold()
                                   .font(.system(size: 28))
                                   .foregroundColor(blkText)
                               Text(" Air casting - with Apple watch or iPhone ")
                                   .bold()
                                   .font(.system(size: 17))
                                   .foregroundColor(blkText)
                               Text(" ")
                               Text(" Practice you casting stroke. Correct bad habits,")
                                   .foregroundColor(blkText)
                                   .font(.system(size: 14))
                               Text(" build good mustle memory ")
                                   .foregroundColor(blkText)
                                   .font(.system(size: 14))
                               Text(" With iPhone: Hold it in your hand like a fly rod. Tap [START} and pantomime a cast. ")
                                   .foregroundColor(blkText)
                                   .font(.system(size: 14))
                               Text(" With APPLE WATCH: Hold its straps like a rod grip")
                                   .foregroundColor(blkText)
                                   .font(.system(size: 14))
                               // Text(" ")
                           }

                           VStack{
                               Text(" ")
                               Text(" Rod cast - with the Apple watch ")
                                   .bold()
                                   .font(.system(size: 20))
                                   .foregroundColor(blkText)

                               HStack{
                                   Text(" Straps alonge the grip, held by rubber bands. Thumb on top. ")
                                       .foregroundColor(blkText)
                                       .font(.system(size: 14))
                                       Image("inlinemount")
                               }
                           }

                            VStack{
                                Text(" ")
                                Text(" Apple watch paired to iPhone ")
                                    .bold()
                                    .font(.system(size: 20))
                                    .foregroundColor(blkText)
                                Text(" ")
                                Text(" Start the iPhone app, then the Apple watch app. Tap [START] ont the Apple watch ")
                                    .foregroundColor(blkText)
                                    .font(.system(size: 14))
                                Text(" ")
                                Text(" Select different moves to work on ")
                                    .bold()
                                    .font(.system(size: 20))
                                    .foregroundColor(blkText)
                                Text(" Also practice keeping strokes straight and making strokes stop crisply. Tap [SETTINGS] on the main page to select the skill to work on. ")
                                    .foregroundColor(blkText)
                                    .font(.system(size: 14))
                                Text(" ")
                                Text(" How to Practice ")
                                    .bold()
                                    .font(.system(size: 22))
                                    .padding(3)
                                    .foregroundColor(blkText)
                            }

                           Spacer()

                HStack{

                    Button(action: {
                        go2Stroke()
                    }, label: {
                        Text("STROKE")
                            .bold()
                            .padding(10)
                            .frame(height:40)
                            .background(greenBtn)
                            .foregroundColor(.white)
                            // .cornerRadius(3)
                            .font(.system(size: 15))
                    })

                    Button(action: {
                        go2Stop()
                    }, label: {
                        Text("STOP")
                            .bold()
                            .padding(10)
                            .frame(height:40)
                            .background(greenBtn)
                            .foregroundColor(.white)
                            // .cornerRadius(3)
                            .font(.system(size: 15))
                    })

                    Button(action: {
                        go2Straight()
                    }, label: {
                        Text("STRAIGHT")
                            .bold()
                            .padding(10)
                            .frame(height:40)
                            .background(greenBtn)
                            .foregroundColor(.white)
                            // .cornerRadius(3)
                            .font(.system(size: 15))
                    })
                    
                    Button(action: {
                        goHome()
                    }, label: {
                        Text("< BACK <")
                            .padding(10)
                            .font(.system(size: 16))
                            .background(greenBtn)
                            .foregroundColor(.white)
                    })

             }

       }
     }

  }

}

    struct HelpScreenController: PreviewProvider {
        static var previews: some View {
            HelpController()

        }
    }

    }



