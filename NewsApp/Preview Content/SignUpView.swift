//
//  SignUpView.swift
//  NewsApp
//
//  Created by Dilip on 2024-06-20.
//

import SwiftUI

import SwiftUI

struct SignUpView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
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
                    .frame(width: 100, height: 100)
                    .padding(.bottom, 50)

                // Username field
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .padding(.horizontal, 20)

                // Email field
                TextField("Email", text: $email)
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

                // Sign Up button
                Button(action: {
                    // Handle sign up action
                    print("Sign Up tapped")
                }) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.yellow)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
                .padding(.top, 30)

                // Sign In button
                NavigationLink(destination: SignInView()) {
                    Text("Already have an account? Sign In")
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
                .padding(.top, 10)

                Spacer()
            }
            .padding(.top, 50)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

