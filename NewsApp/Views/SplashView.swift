//
//  SplashView.swift
//  NewsApp
//
//  Created by Dilip on 2024-06-20.
//

import SwiftUI
import FirebaseAuth

struct SplashView: View {
    @State private var isActive = false
    @State private var isSignedIn = false

    var body: some View {
        VStack {
            if isActive {
                if isSignedIn {
                    MainView()
                } else {
                    SignInView()
                }
            } else {
                Text("NewsLine")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .onAppear {
                        checkCurrentUser()
                    }
            }
        }
    }

    func checkCurrentUser() {
        if Auth.auth().currentUser != nil {
            self.isSignedIn = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.isActive = true
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
