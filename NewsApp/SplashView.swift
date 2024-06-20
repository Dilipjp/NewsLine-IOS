//
//  SplashView.swift
//  NewsApp
//
//  Created by Dilip on 2024-06-06.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
                    Image(systemName: "app.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding()
                    
                    Text("Welcome to My App")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                }
                .background(Color.blue)
                .foregroundColor(.white)
                .edgesIgnoringSafeArea(.all)
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
