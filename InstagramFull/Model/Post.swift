//
//  Post.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/21/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    //  MARK: - Attributes
    
    var caption : String!
    var likes : Int!
    var imageUrl : String!
    var ownerUid : String!
    var creationDate : Date!
    var postId : String!
    var user : User?
    var didLike = false
    
    init(postId : String! , user : User , dictionary : Dictionary<String , AnyObject>) {
        
        self.user = user
        self.postId = postId
        
        if let caption = dictionary["caption"] as? String {
            self.caption = caption
        }
        
        if let likes = dictionary["likes"] as? Int {
            self.likes = likes
        }
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self.imageUrl = imageUrl
        }
        
        if let ownerUid = dictionary["ownerUid"] as? String {
            self.ownerUid = ownerUid
        }
        
        if let caption = dictionary["caption"] as? String {
            self.caption = caption
        }
        
        if let creationDate = dictionary["creationDate"] as? Double {
            
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
    }
    
    func adjustLikes(addLike: Bool , completion : @escaping(Int) ->()) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        guard let postId = self.postId else {return}

        
        if addLike {
            
            // update user likes structure
            USER_LIKES_REF.child(currentUid).updateChildValues([postId : 1] , withCompletionBlock : { (err , ref) in
                
                //send notification to server
                self.sendLikeNotificationToServer()
                
                //update post likes structure
                POST_LIKES_REF.child(self.postId).updateChildValues([currentUid : 1] , withCompletionBlock : {(err, ref) in
                    
                    self.likes = self.likes + 1
                    self.didLike = true
                    completion(self.likes)
                    POSTS_REF.child(self.postId).child("likes").setValue(self.likes)
                })
            })

            
        } else {
            
            //observe DB for notification ID to remove
            USER_LIKES_REF.child(currentUid).child(postId).observeSingleEvent(of: .value) { (snapshot) in
                
                //notificationID to remove from server
                guard let notificationId = snapshot.value as? String else {return}
                
                //Remove notification from server
                NOTIFICATIONS_REF.child(self.ownerUid).child(notificationId).removeValue(completionBlock: { (err, ref) in
                    
                    //remove like from user like structure
                    USER_LIKES_REF.child(currentUid).child(self.postId).removeValue ( completionBlock : { (err, ref) in
                        
                        //remove likes from post-like structure
                        POST_LIKES_REF.child(self.postId).child(currentUid).removeValue ( completionBlock : { (err, ref) in
                            
                            guard self.likes > 0 else {return}
                            self.likes = self.likes - 1
                            self.didLike = false
                            completion(self.likes)
                            POSTS_REF.child(self.postId).child("likes").setValue(self.likes)
                            
                        })
                    })
                })
            }
        }
    }
    
    func sendLikeNotificationToServer(){
        
        let creationDate = Int(NSDate().timeIntervalSince1970)
        guard let currentUid = Auth.auth().currentUser?.uid else {return}

        
        //only send notification is for post that is not current user
        if currentUid != self.ownerUid {
            
            //notificatuon values
            let values = ["checked" : 0 ,
                          "creationDate" : creationDate,
                          "uid" : currentUid ,
                          "type" : LIKE_INT_VALUE,
                          "postId" : postId] as [String : Any]
            
            //notificaton database refference
            let notoficationRef = NOTIFICATIONS_REF.child(self.ownerUid).childByAutoId()
            
            //upload notification values to DB
            notoficationRef.updateChildValues(values) { (err, ref) in
                USER_LIKES_REF.child(currentUid).child(self.postId).setValue(notoficationRef.key)
            }
        }
    }
 
}
