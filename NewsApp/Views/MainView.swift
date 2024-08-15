import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase


// ViewModel
class MainViewModel: ObservableObject {
    @Published var newsArticles: [NewsArticle] = []
    @Published var weather: WeatherResponse?
    @Published var bookmarks: [NewsArticle] = []
    private var weatherManager = WeatherManager()

    init() {
        weatherManager.$weather.assign(to: &$weather)
        fetchBookmarks()
    }

    func fetchNews() {
        let ref = Database.database().reference(withPath: "news")
        ref.observe(.value) { snapshot in
            var newArticles: [NewsArticle] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot {
                    if let newsArticle = NewsArticle(snapshot: snapshot) {
                        newArticles.append(newsArticle)
                    } else {
                        print("Failed to parse news article from snapshot: \(snapshot)")
                    }
                }
            }
            self.newsArticles = newArticles
        }
    }

    func bookmarkArticle(_ article: NewsArticle) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference(withPath: "users/\(userId)/bookmarks/\(article.id)")
        ref.setValue(article.toDictionary())
    }

    func fetchBookmarks() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference(withPath: "users/\(userId)/bookmarks")
        ref.observe(.value) { snapshot in
            var bookmarks: [NewsArticle] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let article = NewsArticle(snapshot: snapshot) {
                    bookmarks.append(article)
                }
            }
            self.bookmarks = bookmarks
        }
    }
}

// Article Dictionary for Firebase
extension NewsArticle {
    func toDictionary() -> [String: Any] {
        return [
            "title": title,
            "date": DateFormatter.dateFormatter.string(from: date),
            "imageUrl": imageUrl,
            "content": content
        ]
    }
}

struct MainView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var mainViewModel = MainViewModel()
    @State private var navigationPath = NavigationPath()

    private var isAdmin: Bool {
        if let currentUserEmail = authViewModel.currentUserEmail() {
            return currentUserEmail == "admin@gmail.com"
        } else {
            return false
        }
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                if let weather = mainViewModel.weather {
                    VStack {
                        Text("Today's Weather in \(weather.name)")
                            .font(.headline)
                            .padding(.top)

                        Text("\(String(format: "%.2f", weather.main.temp))°C, \(weather.weather.first?.description.capitalized ?? "")")
                            .font(.subheadline)
                            .padding(.bottom)
                    }
                } else {
                    Text("Loading weather...")
                        .font(.subheadline)
                        .padding()
                }

                List(mainViewModel.newsArticles, id: \.self) { article in
                    VStack(alignment: .leading) {
                        RemoteImage(url: article.imageUrl)
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 300)
                            .clipped()
                            .onTapGesture {
                                // Do nothing on image tap
                            }
                        Text(article.title)
                            .font(.headline)
                            .padding(.vertical, 4)

                        Text(article.date, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.bottom, 4)

                        HStack {
                            NavigationLink(destination: NewsDetailView(article: article).environmentObject(mainViewModel)) {
                                Text("View More")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                    .padding(.top, 4)
                            }
                        }

                        
                    }
                    VStack(){
                        if isAdmin {
                            HStack {
                                NavigationLink(destination: EditNewsView(article: article)) {
                                    Text("Edit")
                                        .foregroundColor(.blue)
                                        .padding(.top, 4)
                                }

                                
                            }
                        }
                    }
                    VStack(){
                        if isAdmin {
                            HStack {
                                NavigationLink(destination: DeleteNewsView(article: article).environmentObject(mainViewModel)) {
                                    Text("Delete")
                                        .foregroundColor(.red)
                                        .padding(.top, 4)
                                }
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .onAppear {
                mainViewModel.fetchNews()
            }
            .navigationTitle("NewsLine")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            navigationPath.append("Profile")
                        }) {
                            Text("Profile")
                        }

                        Button(action: {
                            navigationPath.append("Bookmark")
                        }) {
                            Text("Bookmark")
                        }

                        Button(action: {
                            navigationPath.append("About")
                        }) {
                            Text("About")
                        }

                        if isAdmin {
                            Button(action: {
                                navigationPath.append("AddNews")
                            }) {
                                Text("Add News")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                            .foregroundColor(.yellow)
                    }
                }
            }
            .navigationDestination(for: String.self) { destination in
                switch destination {
                case "Profile":
                    ProfileView()
                case "About":
                    AboutView()
                case "AddNews":
                    AddNewsView()
                case "Bookmark":
                    BookmarkView().environmentObject(mainViewModel)
                default:
                    EmptyView()
                }
            }
        }
    }
}



// DateFormatter extension
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

// Preview
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AuthViewModel())
    }
}

