import SwiftUI

struct NewsDetailView: View {
    let article: NewsArticle

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
            }
            .padding()
        }
        .navigationTitle("News Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(item: "\( article.imageUrl))\(article.title)\n\n\(article.content)") {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                }
            }
        }
    }
}
