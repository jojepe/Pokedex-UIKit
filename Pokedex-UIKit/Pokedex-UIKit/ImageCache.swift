//
//  ImageCache.swift
//  Pokedex-UIKit
//
//  Created by Joje on 29/07/25.
//

import UIKit

class ImageCache {
    
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
}
