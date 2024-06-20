//
//  NextView.swift
//  NewsApp
//
//  Created by Dilip on 2024-06-06.
//

import SwiftUI

struct NextView: View {
    @EnvironmentObject var userModel:UserModel
    var body: some View {
        VStack{
            Text("Welcome, \(userModel.username)")
                .font(.largeTitle)
                .padding()
            TextField("Update username", text: $userModel.username)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
        }.padding()
            .navigationTitle("Second View")
        
    }
}

struct NextView_Previews: PreviewProvider {
    static var previews: some View {
        NextView()
            .environmentObject(UserModel())
    }
}
