//
//  SignInView.swift
//  NewsApp
//
//  Created by Dilip on 2024-06-20.
//

import SwiftUI

struct SignInView: View {
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(gradient: Gradient(colors: [Color.white, Color.yellow]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    // App icon
                    Image("app_icon") // Ensure the name matches the image in Assets.xcassets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .padding(.bottom, 50)

                    // Username field
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .padding(.horizontal, 20)

                    // Password field
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .padding(.horizontal, 20)

                    // Sign In button
                    Button(action: {
                        // Handle sign in action
                        print("Sign In tapped")
                    }) {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                            .frame(width: 200, height: 50)
                            .background(Color.yellow)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                    .padding(.top, 30)

                    // Sign Up button
                    NavigationLink(destination: SignUpView()) {
                        Text("Don't have an account? Sign Up")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                    .padding(.top, 10)

                    Spacer()
                }
                .padding(.top, 100)
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
