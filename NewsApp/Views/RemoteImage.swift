//
//  RemoteImage.swift
//  NewsApp
//
//  Created by Dilip on 2024-06-26.
//

import SwiftUI

struct RemoteImage: View {
    let url: String
    @State private var image: UIImage? = nil
    @State private var isLoading = true
    @State private var errorMessage: String? = nil

    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
            } else if let image = image {
                GeometryReader { geometry in
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: 300)
                        .clipped()
                }
            } else if let errorMessage = errorMessage {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
            }
        }
        .frame(height: 300)
        .onAppear {
            loadImage(from: URL(string: url))
        }
    }

    private func loadImage(from url: URL?) {
        guard let url = url else {
            isLoading = false
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    errorMessage = "Error loading image: \(error.localizedDescription)"
                    return
                }
                guard let data = data, let loadedImage = UIImage(data: data) else {
                    errorMessage = "Failed to load image"
                    return
                }
                self.image = loadedImage
            }
        }.resume()
    }
}




