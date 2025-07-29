//
//  UIImageView+Extensions.swift
//  Pokedex-UIKit
//
//  Created by Joje on 29/07/25.
//

import UIKit

extension UIImageView{
    
    func loadImage(from url: URL) {
        let cacheKey = url.absoluteString
        
        if let cachedImage = ImageCache.shared.get(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let data = data,
                  let image = UIImage(data: data) else {
                return
            }
            
            ImageCache.shared.set(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }
}
