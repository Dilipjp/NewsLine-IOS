//
//  ContentView.swift
//  NewsApp
//
//  Created by Dilip on 2024-06-06.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var userModel =  UserModel()
    @State private var showSplashScreen = true
    var body: some View {
        NavigationView{
            VStack{
                if showSplashScreen{
                    SplashView().onAppear {
                                               DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                   withAnimation {
                                                       showSplashScreen = false
                                                   }
                                               }
                                           }
                }else{
                    VStack{
                        TextField("Enter username", text:$userModel.username).padding().textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        NavigationLink(destination: NextView().environmentObject(userModel)){
                            Text("Go to Next View")
                                .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                                .padding()
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            
                        }
                    }.padding()
                        
                }
            }
            
            
        }.environmentObject(userModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserModel())
    }
}
