//
//  CustomImageView.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/22/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit

var imageCache = [String : UIImage]()

class CustomImageView: UIImageView {
    
    var LastImageUrlUsedToLoadImage : String?
    
    func loadImage(with urlString : String) {
        
        //ser image to nil
        self.image = nil
        
        //set lastImageUrlToLoadImage
        self.LastImageUrlUsedToLoadImage = urlString
        
        //check if image exists in cache
        if let cachedImage = imageCache[urlString]{
            self.image = cachedImage
            return
        }
        
        //url for image location
        guard let url = URL(string: urlString) else {return}
        
        //fetch contents of URL
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            //handle error
            
            if let error = error {
                print("failed to load image with error",error.localizedDescription)
            }
            
            if self.LastImageUrlUsedToLoadImage != url.absoluteString {
                
                return
            }
            
            //get image data
            guard let imageData = data else {return}
            
            //set image using image Data
            let photoImage = UIImage(data: imageData)
            
            //set key and value for image cache
            imageCache[url.absoluteString] = photoImage
            
            //set image
            DispatchQueue.main.async {
                self.image = photoImage
            }
            }.resume()
        
    }
    
    
    
    
}
