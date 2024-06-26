//
//  AuthViewModel.swift
//  NewsApp
//
//  Created by Dilip on 2024-06-20.
//

import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isSignedIn: Bool = false
    @Published var currentUserEmail: String?

    init() {
        self.isSignedIn = Auth.auth().currentUser != nil
        //fetchCurrentUserEmail()
        Auth.auth().addStateDidChangeListener { (auth, user) in
                    if let user = user {
                        self.currentUserEmail = user.email ?? ""
                    } else {
                        self.currentUserEmail = ""
                    }
                }
    }
    
    func fetchCurrentUserEmail() {
            if let currentUser = Auth.auth().currentUser {
                self.currentUserEmail = currentUser.email
            } else {
                self.currentUserEmail = nil
            }
        }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isSignedIn = false
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }

    func signIn() {
        self.isSignedIn = true
    }
}
