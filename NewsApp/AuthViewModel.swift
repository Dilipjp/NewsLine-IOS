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

    init() {
        self.isSignedIn = Auth.auth().currentUser != nil
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
