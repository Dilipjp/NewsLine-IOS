//
//  NewsDetails.swift
//  NewsApp
//
//  Created by Dilip on 2024-06-26.
//

import Foundation
import SwiftUI

struct NewsDetailView: View {
    let article: NewsArticle

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                RemoteImage(url: article.imageUrl)
                    .aspectRatio(contentMode: .fill)
                                       .frame(height: 300)
                                       .clipped()

                VStack(alignment: .leading, spacing: 8) {
                    Text(article.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.horizontal)

                    Text(article.date, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)

                    Divider()
                        .padding(.horizontal)

                    Text(article.content)
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding([.leading, .trailing, .bottom])
                }
                .background(Color(UIColor.systemBackground))
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding([.leading, .trailing, .bottom])
            }
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        }
        .navigationTitle("News Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}




