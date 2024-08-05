import SwiftUI
import Firebase
import FirebaseDatabase

struct EditNewsView: View {
    @State var article: NewsArticle
    @State private var title: String
    @State private var content: String
    @State private var date: Date
    @State private var imageUrl: String
    @State private var errorMessage: String = ""

    init(article: NewsArticle) {
        self._article = State(initialValue: article)
        self._title = State(initialValue: article.title)
        self._content = State(initialValue: article.content)
        self._date = State(initialValue: article.date)
        self._imageUrl = State(initialValue: article.imageUrl)
    }

    var body: some View {
        VStack {
            Text("Edit News")
                .font(.largeTitle)
                .padding()

            TextField("Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            DatePicker("Select date", selection: $date, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
            TextField("Image Url", text: $imageUrl)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextEditor(text: $content)
                .border(Color.gray, width: 1)
                .padding()

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: {
                updateNews()
            }) {
                Text("Update News")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(Color.black)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .padding()
    }

    func updateNews() {
        let ref = Database.database().reference(withPath: "news").child(article.id)
        let dateString = DateFormatter.dateFormatter.string(from: date)
        let updatedArticle = [
            "title": title,
            "content": content,
            "date": dateString,
            "imageUrl": imageUrl
        ]

        ref.updateChildValues(updatedArticle) { error, _ in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                errorMessage = "Article updated successfully."
            }
        }
    }
}


