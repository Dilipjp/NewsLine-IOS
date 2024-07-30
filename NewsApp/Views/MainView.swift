import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase

// Model
struct NewsArticle: Identifiable, Hashable {
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
    }
}

// ViewModel
class MainViewModel: ObservableObject {
    @Published var newsArticles: [NewsArticle] = []

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
                            NavigationLink(destination: NewsDetailView(article: article)) {
                                Text("View More")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                    .padding(.top, 4)
                            }
                        }
                        
                    }
                    VStack(alignment: .leading){
                        HStack{
                            if isAdmin {
                                Spacer()
                                NavigationLink(destination: EditNewsView(article: article)) {
                                    Text("Edit")
                                        .foregroundColor(.blue)
                                        .padding(.top, 4)
                                }
                               
                            }
                        }
                    }
                    VStack(alignment: .leading){
                        HStack{
                            if isAdmin {
                                
                                Spacer()
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
            .navigationTitle("Latest News")
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
                            .foregroundColor(.blue)
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

