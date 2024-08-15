//
//  BookmarkView.swift
//  NewsApp
//
//  Created by Dilip on 2024-08-15.
//

import SwiftUI
// BookmarkView
struct BookmarkView: View {
    @EnvironmentObject var mainViewModel: MainViewModel

    var body: some View {
        VStack {
            if mainViewModel.bookmarks.isEmpty {
                Text("No bookmarks yet.")
                    .font(.headline)
                    .padding()
            } else {
                List(mainViewModel.bookmarks, id: \.self) { article in
                    NavigationLink(destination: NewsDetailView(article: article)) {
                        Text(article.title)
                            .font(.headline)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("Bookmarks")
        .navigationBarTitleDisplayMode(.inline)
    }
}
