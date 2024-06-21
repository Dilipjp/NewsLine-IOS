//
//  MainView.swift
//  NewsApp
//
//  Created by Dilip on 2024-06-20.
//
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct NewsArticle: Identifiable {
    let id: String
    let title: String
    let date: Date
    let imageUrl: String
    let content: String

    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
              let title = value["title"] as? String,
              let dateString = value["date"] as? String,
              let imageUrl = value["imageUrl"] as? String,
              let content = value["content"] as? String,
              let date = DateFormatter.date(from: dateString) else {
            return nil
        }
        self.id = snapshot.key
        self.title = title
        self.date = date
        self.imageUrl = imageUrl
        self.content = content
    }
}

struct RemoteImage: View {
    let url: String
    @State private var image: UIImage? = nil

    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else {
            // Placeholder image while loading
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .onAppear {
                    loadImage(from: URL(string: url))
                }
        }
    }

    private func loadImage(from url: URL?) {
        guard let url = url else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let loadedImage = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                self.image = loadedImage
            }
        }.resume()
    }
}

struct MainView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var newsArticles: [NewsArticle] = []

    var body: some View {
        VStack {
            Text("Latest news")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            List(newsArticles) { article in
                VStack(alignment: .leading) {
                    RemoteImage(url: article.imageUrl)
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()

                    Text(article.title)
                        .font(.headline)
                        .padding(.vertical, 4)

                    Text(article.date, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 4)

                    Button(action: {
                        // Handle "View More" action
                    }) {
                        Text("View More")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .padding(.top, 4)
                    }
                }
                .padding()
            }

            Spacer()

            Button(action: {
                authViewModel.signOut()
            }) {
                Text("Sign Out")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            fetchNews()
            //addNewsToDatabase()
        }
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
    
//    struct NewsArticle1 {
//        let id: String
//        let title: String
//        let date: String
//        let imageUrl: String
//        let content: String
//
//        var dictionary: [String: Any] {
//            return [
//                "title": title,
//                "date": date,
//                "imageUrl": imageUrl,
//                "content": content
//            ]
//        }
//    }
//    
//    func addNewsToDatabase() {
//        let newsArticles1 = [
//            NewsArticle1(id: "1", title: "News 1", date: "2023-06-21T12:00:00Z", imageUrl: "https://example.com/image1.jpg", content: "Content of News 1"),
//            NewsArticle1(id: "2", title: "News 2", date: "2023-06-21T13:00:00Z", imageUrl: "https://example.com/image2.jpg", content: "Content of News 2"),
//            NewsArticle1(id: "3", title: "News 3", date: "2023-06-21T14:00:00Z", imageUrl: "https://example.com/image3.jpg", content: "Content of News 3"),
//            NewsArticle1(id: "4", title: "News 4", date: "2023-06-21T15:00:00Z", imageUrl: "https://example.com/image4.jpg", content: "Content of News 4"),
//            NewsArticle1(id: "5", title: "News 5", date: "2023-06-21T16:00:00Z", imageUrl: "https://example.com/image5.jpg", content: "Content of News 5"),
//            NewsArticle1(id: "6", title: "News 6", date: "2023-06-21T17:00:00Z", imageUrl: "https://example.com/image6.jpg", content: "Content of News 6"),
//            NewsArticle1(id: "7", title: "News 7", date: "2023-06-21T18:00:00Z", imageUrl: "https://example.com/image7.jpg", content: "Content of News 7"),
//            NewsArticle1(id: "8", title: "News 8", date: "2023-06-21T19:00:00Z", imageUrl: "https://example.com/image8.jpg", content: "Content of News 8"),
//            NewsArticle1(id: "9", title: "News 9", date: "2023-06-21T20:00:00Z", imageUrl: "https://example.com/image9.jpg", content: "Content of News 9"),
//            NewsArticle1(id: "10", title: "News 10", date: "2023-06-21T21:00:00Z", imageUrl: "https://example.com/image10.jpg", content: "Content of News 10")
//        ]
//
//        let ref = Database.database().reference(withPath: "news")
//        for article in newsArticles1 {
//            ref.child(article.id).setValue(article.dictionary) { error, _ in
//                if let error = error {
//                    print("Error adding news: \(error.localizedDescription)")
//                } else {
//                    print("News added successfully")
//                }
//            }
//        }
//    }
}

extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()

    static func date(from string: String) -> Date? {
        return dateFormatter.date(from: string)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(AuthViewModel())
    }
}






