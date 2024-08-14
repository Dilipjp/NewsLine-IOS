import SwiftUI
import Firebase
import FirebaseDatabase

struct NewsDetailView: View {
    let article: NewsArticle
    @State private var userRating: Double?

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
                ShareLink(item: "\(article.imageUrl)\n\n\(article.title)\n\n\(article.content)") {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                }
            }
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
}

