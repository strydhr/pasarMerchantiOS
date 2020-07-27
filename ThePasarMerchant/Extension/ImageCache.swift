//
//  ImageCache.swift
//  Food App
//
//  Created by Satyia Anand on 11/03/2019.
//  Copyright © 2019 Satyia Anand. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func cacheImage(imageUrl: String){
        guard let url = URL(string: imageUrl) else {return}
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: imageUrl as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let response = data {
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data!)
                    imageCache.setObject(imageToCache!, forKey: imageUrl as AnyObject)
                    self.image = imageToCache
                }
            }
            }.resume()
    }
    

}

