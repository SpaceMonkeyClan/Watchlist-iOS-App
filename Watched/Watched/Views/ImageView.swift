//
//  ImageView.swift
//  Watched
//
//  Created by Rene Dena on 4/23/21.
//

import UIKit
import SwiftUI

/// Image view that is capable of download an image from URL
struct ImageView: View {
    
    @ObservedObject private var imageData: ImageData
    
    /// Init the image view with a URL
    /// - Parameter imageURL: full image URL
    init(imageURL: String) {
        imageData = ImageData(url: imageURL)
    }
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            AppConfig.darkGrayColor
            if imageData.image == nil {
                Image(systemName: "film")
            } else {
                Image(uiImage: imageData.image!)
                    .resizable().scaledToFill().clipped()
            }
        }.font(.system(size: 40))
    }
    
    /// Observable image data file to download the image
    class ImageData: ObservableObject {
        @Published var image: UIImage?
        private var imageURL: String
    
        /// Init downloader with URL
        /// - Parameter url: image URL
        init(url: String) {
            imageURL = url
            downloadImage()
        }
        
        /// Start downloading the image
        private func downloadImage() {
            if let cachedImage = CachedImages.cachedImage(forKey: imageURL) {
                image = cachedImage
                return
            }
            guard let url = URL(string: imageURL) else { return }
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                DispatchQueue.main.async {
                    if let imageData = data, let downloadedImage = UIImage(data: imageData) {
                        self.image = downloadedImage
                        CachedImages.cacheImage(downloadedImage, key: self.imageURL)
                    }
                }
            }.resume()
        }
    }
}

// MARK: - Cached images
class CachedImages {
    static var data = NSCache<NSString, UIImage>()
    static func cacheImage(_ image: UIImage, key: String) {
        CachedImages.data.setObject(image, forKey: key as NSString)
    }
    static func cachedImage(forKey key: String) -> UIImage? {
        CachedImages.data.object(forKey: key as NSString)
    }
}

// MARK: - Preview UI
struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(imageURL: "https://image.tmdb.org/t/p/w185/pgqgaUx1cJb5oZQQ5v0tNARCeBp.jpg")
    }
}
