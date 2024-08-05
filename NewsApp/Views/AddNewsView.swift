import SwiftUI
import Firebase
import FirebaseDatabase

struct AddNewsView: View {
    @State private var title = ""
    @State private var date = Date()
    @State private var imageUrl = ""
    @State private var content = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .leading) {
            Text("Add News")
                .font(.largeTitle)
                .padding()

            Form {
                Section(header: Text("Article Title")) {
                    TextField("Enter title", text: $title)
                }

                Section(header: Text("Date")) {
                    DatePicker("Select date", selection: $date, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                }

                Section(header: Text("Image URL")) {
                    TextField("Enter image URL", text: $imageUrl)
                }

                Section(header: Text("Content")) {
                    TextEditor(text: $content)
                        .frame(height: 200)
                }
            }

            Spacer()

            Button(action: {
                addNews()
            }) {
                Text("Add News")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(Color.black)
                    .cornerRadius(10)
            }
            .padding()
        }
    }

    func addNews() {
        let ref = Database.database().reference(withPath: "news").childByAutoId()
        let dateString = DateFormatter.dateFormatter.string(from: date)
        let newsData: [String: Any] = [
            "title": title,
            "date": dateString,
            "imageUrl": imageUrl,
            "content": content
        ]

        ref.setValue(newsData) { error, _ in
            if let error = error {
                print("Error adding news: \(error.localizedDescription)")
            } else {
                print("News added successfully")
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct AddNewsView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewsView()
    }
}
