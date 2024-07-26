//
//  DeleteNewsView.swift
//  NewsApp
//
//  Created by Dilip on 2024-07-08.
//

import SwiftUI
import Firebase
import FirebaseDatabase

struct DeleteNewsView: View {
    var article: NewsArticle
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var mainViewModel: MainViewModel

    var body: some View {
        VStack {
            Text("Are you sure you want to delete this article?")
                .font(.title2)
                .padding()

            HStack {
                Button(action: {
                    deleteNews()
                }) {
                    Text("Yes")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }

                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("No")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
    }

    func deleteNews() {
        let ref = Database.database().reference(withPath: "news").child(article.id)
        ref.removeValue { error, _ in
            if let error = error {
                print("Error deleting article: \(error.localizedDescription)")
            } else {
                mainViewModel.fetchNews()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}


