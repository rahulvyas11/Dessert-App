//
//  URLImage.swift
//  Fetch Take Home
//
//  Created by Rahul Vyas on 5/14/24.
//
import SwiftUI

struct URLImage: View {
    let url: URL
    
    @State private var data: Data?
    @State private var isImageLoaded = false
    @State private var showErrorImage = false // New state for error handling

    var body: some View {
        Group {
            if isImageLoaded, let data = data, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if showErrorImage {
                Image("placeholderThumb")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.3)) // Optional background color
                    .onAppear(perform: fetchData)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .aspectRatio(contentMode: .fill)
    }

    private func fetchData() {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, UIImage(data: data) != nil {
                DispatchQueue.main.async {
                    self.data = data
                    self.isImageLoaded = true
                }
            } else {
                DispatchQueue.main.async {
                    self.showErrorImage = true
                }
            }
        }.resume()
    }
}
