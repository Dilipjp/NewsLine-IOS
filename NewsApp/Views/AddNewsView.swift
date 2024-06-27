//
//  AddNewsView.swift
//  NewsApp
//
//  Created by Dilip on 2024-06-27.
//

import SwiftUI
import Firebase

struct NewsArticleAdd {
    let title: String
    let date: String // Use String for Firebase's date format
    let imageUrl: String
    let content: String

    // Convert to dictionary for Firebase serialization
    var asDictionary: [String: Any] {
        return [
            "title": title,
            "date": date,
            "imageUrl": imageUrl,
            "content": content
        ]
    }
}

struct AddNewsView: View {
    @State private var title = ""
    @State private var dateString = ""
    @State private var imageUrl = ""
    @State private var content = ""
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isShowingAlert = false
    @State private var alertMessage = ""
    @State private var isNewsSaved = false // Track if news is saved successfully
    
    var body: some View {
        VStack {
            Text("Add News")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Form {
                Section(header: Text("News Details")) {
                    TextField("Title", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Date (YYYY-MM-DDTHH:mm:ssZ)", text: $dateString)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: dateString, perform: { value in
                            self.dateString = formatDate(dateString)
                        })
                    
                    TextField("Image URL", text: $imageUrl)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextEditor(text: $content)
                        .frame(minHeight: 100)
                        .cornerRadius(5)
                }
                
                Button(action: {
                    saveNews()
                }) {
                    Text("Save News")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationBarTitle("Add News", displayMode: .inline)
            
            // Show success message if news is saved
            if isNewsSaved {
                Text("News saved successfully.")
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .padding()
    }
    
    func saveNews() {
        guard !title.isEmpty else {
            showAlert(message: "Please enter a title.")
            return
        }
        guard !dateString.isEmpty else {
            showAlert(message: "Please enter a date.")
            return
        }
        guard !imageUrl.isEmpty else {
            showAlert(message: "Please enter an image URL.")
            return
        }
        
        let newsRef = Database.database().reference().child("news").childByAutoId()
        let news = NewsArticleAdd(title: title, date: dateString, imageUrl: imageUrl, content: content)
        newsRef.setValue(news.asDictionary) { error, _ in
            if let error = error {
                showAlert(message: "Error saving news: \(error.localizedDescription)")
            } else {
                print("News saved successfully.")
                isNewsSaved = true // Set flag to true when news is saved
                clearFields() // Clear all fields after saving
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isNewsSaved = false // Reset flag after showing success message
                }
                //presentationMode.wrappedValue.dismiss() // Dismiss the view after saving (optional)
            }
        }
    }
    
    func clearFields() {
        title = ""
        dateString = ""
        imageUrl = ""
        content = ""
    }
    
    func formatDate(_ dateString: String) -> String {
        // Assuming dateString is in the format "YYYY-MM-DD"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        let date = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.string(from: date ?? Date())
    }
    
    func showAlert(message: String) {
        alertMessage = message
        isShowingAlert = true
    }
}

struct AddNewsView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewsView()
    }
}






