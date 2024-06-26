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

struct MainView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var newsArticles: [NewsArticle] = []

    // Computed property to check if current user is admin
    private var isAdmin: Bool {
        authViewModel.currentUserEmail == "admin@gmail.com"
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Latest News")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                // Show Add News button only if user is admin
                if isAdmin {
                    HStack {
                        Spacer()
                        Button(action: {
                            // Action to add news, e.g., navigate to add news screen
                            print("Add News button tapped")
                        }) {
                            Text("Add News")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .padding()
                        }
                    }
                }

                List(newsArticles) { article in
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
                    }
                    .padding()
                }
                .listStyle(PlainListStyle())

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
            }
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
            // Debugging: Print fetched articles
            for article in newArticles {
                print("Fetched article: \(article.title), Image URL: \(article.imageUrl)")
            }
        }
    }
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











