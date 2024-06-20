//
//  SignInView.swift
//  NewsApp
//
//  Created by Dilip on 2024-06-20.
//

import SwiftUI

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @ObservedObject var firebaseService: FirebaseService

    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $email)
                    .padding()

                SecureField("Password", text: $password)
                    .padding()

                Button("Sign In") {
                    firebaseService.signIn(email: email, password: password) { success, error in
                        if let error = error {
                            print("Sign in failed: \(error.localizedDescription)")
                        }
                    }
                }
                .padding()

                NavigationLink(destination: MainView(), isActive: $firebaseService.isLoggedIn) {
                    EmptyView()
                }
            }
            .padding()
        }
    }
}
