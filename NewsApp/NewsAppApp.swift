//
//  NewsAppApp.swift
//  NewsApp
//
//  Created by Dilip on 2024-06-06.
//

import SwiftUI
import Firebase

@main
struct MyAppApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
