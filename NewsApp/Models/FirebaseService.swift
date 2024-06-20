//
//  FirebaseService.swift
//  NewsApp
//
//  Created by Dilip on 2024-06-20.
//

import Foundation
// FirebaseService.swift

import Firebase

class FirebaseService: ObservableObject {
    @Published var isLoggedIn: Bool = false

    func signIn(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let _ = result {
                self.isLoggedIn = true
                completion(true, nil)
            } else if let error = error {
                self.isLoggedIn = false
                completion(false, error)
            }
        }
    }

    func signUp(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let _ = result {
                completion(true, nil)
            } else if let error = error {
                completion(false, error)
            }
        }
    }

    func signOut() {
        try? Auth.auth().signOut()
        self.isLoggedIn = false
    }
}

