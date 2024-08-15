import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseAuth

struct NewsDetailView: View {
    let article: NewsArticle
    @State private var userRating: Double?
    @State private var isBookmarked = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                RemoteImage(url: article.imageUrl)
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .clipped()

                Text(article.title)
                    .font(.largeTitle)
                    .padding(.vertical, 4)

                Text(article.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 4)

                Text(article.content)
                    .font(.body)
                    .padding(.vertical, 4)

                // Rating Section
                VStack {
                    Text("Rate this article")
                        .font(.headline)
                        .padding(.top)

                    HStack {
                        ForEach(1..<6) { star in
                            Image(systemName: star <= Int(userRating ?? article.rating ?? 0) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .onTapGesture {
                                    userRating = Double(star)
                                    saveRating(rating: Double(star))
                                }
                        }
                    }
                    .font(.largeTitle)
                }
                .padding(.vertical)
            }
            .padding()
        }
        .navigationTitle("News Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: {
                        toggleBookmark()
                    }) {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                            .font(.title2).foregroundColor(.yellow)
                    }
                    
                    ShareLink(item: "\(article.imageUrl)\n\n\(article.title)\n\n\(article.content)") {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title2).foregroundColor(.yellow)
                    }
                }
            }
        }
        .onAppear {
            checkIfBookmarked()
        }
    }

    private func saveRating(rating: Double) {
        let ref = Database.database().reference(withPath: "news/\(article.id)/rating")
        ref.setValue(rating) { error, _ in
            if let error = error {
                print("Error saving rating: \(error.localizedDescription)")
            } else {
                print("Rating saved successfully!")
            }
        }
    }

    private func toggleBookmark() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference(withPath: "users/\(userId)/bookmarks/\(article.id)")

        if isBookmarked {
            ref.removeValue { error, _ in
                if let error = error {
                    print("Error removing bookmark: \(error.localizedDescription)")
                } else {
                    isBookmarked = false
                    print("Bookmark removed")
                }
            }
        } else {
            let bookmarkData: [String: Any] = [
                "id": article.id,
                "title": article.title,
                "date": DateFormatter.dateFormatter.string(from: article.date),
                "imageUrl": article.imageUrl,
                "content": article.content
            ]
            ref.setValue(bookmarkData) { error, _ in
                if let error = error {
                    print("Error saving bookmark: \(error.localizedDescription)")
                } else {
                    isBookmarked = true
                    print("Bookmark added")
                }
            }
        }
    }

    private func checkIfBookmarked() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference(withPath: "users/\(userId)/bookmarks/\(article.id)")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            isBookmarked = snapshot.exists()
        }
    }
}
