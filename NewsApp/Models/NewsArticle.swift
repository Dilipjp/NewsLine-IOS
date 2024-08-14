//
//  NewsArticle.swift
//  NewsApp
//
//  Created by Dilip on 2024-07-05.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct NewsArticle: Identifiable, Hashable {
    let id: String
    let title: String
    let date: Date
    let imageUrl: String
    let content: String
    var rating: Double? // Add this property

    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
              let title = value["title"] as? String,
              let dateString = value["date"] as? String,
              let imageUrl = value["imageUrl"] as? String,
              let content = value["content"] as? String else {
            print("Failed to parse news article data")
            return nil
        }

        guard let date = DateFormatter.date(from: dateString) else {
            print("Failed to parse date string into Date object: \(dateString)")
            return nil
        }

        self.id = snapshot.key
        self.title = title
        self.date = date
        self.imageUrl = imageUrl
        self.content = content
        self.rating = value["rating"] as? Double // Initialize the rating
    }
}

