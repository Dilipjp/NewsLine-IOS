//
//  NewsArticleView.swift
//  NewsApp
//
//  Created by Dilip on 2024-07-05.
//

import SwiftUI
import Firebase

struct NewsArticleView: View {
    let article: NewsArticle
    let isAdmin: Bool
    @State private var navigationPath = NavigationPath()

    var body: some View {
        VStack(alignment: .leading) {
            RemoteImage(url: article.imageUrl)
                .aspectRatio(contentMode: .fill)
                .frame(height: 300)
                .clipped()
            Text(article.title)
                .font(.headline)
                .padding(.vertical, 4)

            Text(article.date, style: .date)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 4)

            NavigationLink(destination: NewsDetailView(article: article)) {
                Text("View More")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .padding(.top, 4)
            }

            if isAdmin {
                HStack {
                    NavigationLink(destination: EditNewsView(article: article)) {
                        Text("Edit")
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing, 8)

                    Button(action: {
                        deleteNews(article)
                    }) {
                        Text("Delete")
                            .foregroundColor(.red)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding()
    }

    func deleteNews(_ article: NewsArticle) {
        let ref = Database.database().reference(withPath: "news").child(article.id)
        ref.removeValue { error, _ in
            if let error = error {
                print("Error deleting article: \(error.localizedDescription)")
            } else {
                // Optionally handle UI updates here
            }
        }
    }
}
