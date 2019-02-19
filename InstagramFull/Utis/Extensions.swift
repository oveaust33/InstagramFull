//
//  Extensions.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/12/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit
import Firebase
extension UIView {
    func anchor (top : NSLayoutYAxisAnchor? , left: NSLayoutXAxisAnchor? , bottom : NSLayoutYAxisAnchor? , right : NSLayoutXAxisAnchor? , paddingTop : CGFloat , paddingLeft : CGFloat , paddingBottom : CGFloat , paddingRight : CGFloat , width : CGFloat , height : CGFloat){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top , constant: paddingTop).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left , constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom , constant: -paddingBottom).isActive = true
        }
        if let right = right {
            self.rightAnchor.constraint(equalTo: right , constant: -paddingRight).isActive = true
        }
        if  width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
}



var imageCache = [String : UIImage]()
extension UIImageView {
    func loadImage(with urlString : String) {
        
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

extension Database {
    static func fetchUser (with uid : String , completion : @escaping(User)->()) {
        USER_REF.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String,AnyObject> else {return}
            let user = User(uid: uid, dictionary: dictionary)
            
            completion(user)
        }
    }
    
}
