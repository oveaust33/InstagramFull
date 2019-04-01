//
//  Extensions.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/12/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit
import Firebase

extension UIViewController {
    
    func getMentionedUser(WithUserName userName : String){
        
        USER_REF.observe(.childAdded) { (snapshot) in
            
            let uid = snapshot.key
            
            USER_REF.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? Dictionary<String,AnyObject> else {return}
                
                if userName == dictionary["userName"] as? String {
                    
                    Database.fetchUser(with: uid, completion: { (user) in
                        let userProfileController = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
                        userProfileController.user = user
                        self.navigationController?.pushViewController(userProfileController, animated: true)
                        return
                    })
                }
            })
        }
    }
    
    func uploadMentiondNotification(forPostId postId: String , withTextId text : String , isForComment : Bool){
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        let words = text.components(separatedBy: .whitespacesAndNewlines)
        
        var mentionIntegarValue : Int!
        
        if isForComment{
            
            mentionIntegarValue = COMMENT_MENTION_INT_VALUE
            
        } else {
            
            mentionIntegarValue = POST_MENTION_INT_VALUE
            
            
        }
        
        for var word in words{
            
            if word.hasPrefix("@"){
                
                word = word.trimmingCharacters(in: .symbols)
                word = word.trimmingCharacters(in: .punctuationCharacters)
                
                USER_REF.observe(.childAdded) { (snapshot) in
                    
                    let uid = snapshot.key
                    USER_REF.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        guard let dictionary = snapshot.value as? Dictionary<String,AnyObject> else {return}
                        
                        if word == dictionary["userName"] as? String {
                            
                            let notificationValues = [  "postId" : postId,
                                                        "uid"    : currentUid,
                                                        "type"   : mentionIntegarValue,
                                                        "creationDate" : creationDate] as [String : Any]
                            
                            if currentUid != uid {
                                
                                NOTIFICATIONS_REF.child(uid).childByAutoId().updateChildValues(notificationValues)
                            }
                        }
                    })
                }
            }
        }
    }
    
}

extension UIColor {
    static func rgb(red : CGFloat , green : CGFloat , blue : CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIButton{
    
    func configure(didFollow : Bool) {
        
        if didFollow {
            
            //Follow User
            self.setTitle("Following", for: .normal)
            self.setTitleColor(.black, for: .normal)
            self.layer.borderWidth = 0.5
            self.layer.borderColor = UIColor.lightGray.cgColor
            self.backgroundColor = .white
            
            
        } else {
            
            //UnFollow User
            self.setTitle("Follow", for: .normal)
            self.setTitleColor(.white, for: .normal)
            self.layer.borderWidth = 0
            self.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)

        }
    }
}





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

extension UIImageView {
 
}

extension Database {
    static func fetchUser (with uid : String , completion : @escaping(User)->()) {
        USER_REF.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String,AnyObject> else {return}
            let user = User(uid: uid, dictionary: dictionary)
            
            completion(user)
        }
    }
    
    static func fetchPost(with postId : String, completion : @escaping(Post)->()){
        POSTS_REF.child(postId).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionary = snapshot.value as? Dictionary<String , AnyObject> else {return}
            guard let ownerUid = dictionary["ownerUid"] as? String else {return}
            
            Database.fetchUser(with: ownerUid, completion: { (user) in
                let post = Post(postId: postId, user: user, dictionary: dictionary)
                
                completion(post)
            })
            
            
            
            
        }
        
    }
    
}
