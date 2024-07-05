import SwiftUI
import Firebase
import FirebaseDatabase

struct ViewEditNewsView: View {
    @State private var newsArticles: [NewsArticle] = []
    @State private var selectedArticle: NewsArticle?

    var body: some View {
        VStack {
            List(newsArticles, id: \.self) { article in
                VStack(alignment: .leading) {
                    Text(article.title)
                        .font(.headline)
                        .padding(.vertical, 4)

                    Text(article.date, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 4)

                    HStack {
                        Button(action: {
                            selectedArticle = article
                        }) {
                            Text("Edit")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                                .padding(.top, 4)
                        }

                        Button(action: {
                            deleteNews(article: article)
                        }) {
                            Text("Delete")
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .padding(.top, 4)
                        }
                    }
                }
                .padding()
            }
            .listStyle(PlainListStyle())
            
        }
        .onAppear {
            fetchNews()
        }
        .navigationTitle("View/Edit News")
        .navigationBarTitleDisplayMode(.inline)
    }

    func fetchNews() {
        let ref = Database.database().reference(withPath: "news")
        ref.observe(.value) { snapshot in
            var newArticles: [NewsArticle] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let newsArticle = NewsArticle(snapshot: snapshot) {
                    newArticles.append(newsArticle)
                }
            }
            self.newsArticles = newArticles
        }
    }

    func deleteNews(article: NewsArticle) {
        let ref = Database.database().reference(withPath: "news").child(article.id)
        ref.removeValue { error, _ in
            if let error = error {
                print("Error deleting news: \(error.localizedDescription)")
            } else {
                self.newsArticles.removeAll { $0.id == article.id }
                print("News deleted successfully")
            }
        }
    }
}

struct ViewEditNewsView_Previews: PreviewProvider {
    static var previews: some View {
        ViewEditNewsView()
    }
}
