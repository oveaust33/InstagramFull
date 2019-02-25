//
//  User.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/15/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//
import Firebase
class User {
    
    //Mark: - Attributes
    var userName : String!
    var name : String!
    var profileImageURL : String!
    var uid : String!
    var isFollowed = false
    
    init(uid : String , dictionary : Dictionary<String , AnyObject>){
        self.uid = uid
        
        //Keys dhore dhore Json data retrieve kora "Keys" : if let (userName) "values"
        
        if let userName = dictionary["userName"] as? String {
            self.userName = userName
        }
        
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        
        if let profileImageURL = dictionary["profileImageURL"] as? String {
            self.profileImageURL = profileImageURL
        }
        
    }
    
    func follow() {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        guard let uid = self.uid else {return}
        
        //set is followed to true
        isFollowed = true

        //add followed user to current user-following structure
        USER_FOLLOWING_REF.child(currentUid).updateChildValues([uid : 1])
        
        //add current user to followed user-follower structure
        USER_FOLLOWER_REF.child(uid).updateChildValues([currentUid : 1])
        
        // add following user's post in feed VC
        USER_POSTS_REF.child(self.uid).observe(.childAdded) { (snapshot) in
            let postId = snapshot.key
            USER_FEED_REF.child(currentUid).updateChildValues([postId : 1])
        }
       
    }
    
    func unfollow() {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        guard let uid = self.uid else {return}
        
        //srt is followed to false
        isFollowed = false
        
        //remove user from current user-following structure
        USER_FOLLOWING_REF.child(currentUid).child(uid).removeValue()
        
        //remove user from user-follower structure
        USER_FOLLOWER_REF.child(uid).child(currentUid).removeValue()
        
        //remove unfollowed user post from FEED VC
        USER_POSTS_REF.child(self.uid).observe(.childAdded) { (snapshot) in
            
            let postId = snapshot.key
            USER_FEED_REF.child(currentUid).child(postId).removeValue()
            
        }
        
    }
    
    //  USER FOLLOWING : ami jake follow kortesi
    //  USER FOLLOWER  : je amake follow kortese
    
    func chekIfUserIsFollowed(completion : @escaping(Bool)->()){
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        USER_FOLLOWING_REF.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            
            //  SNAPSHOT : ami jake jake follow kortesi tader UID
            
            if snapshot.hasChild(self.uid) {
                self.isFollowed = true
                completion(true)
            }
            else {
                self.isFollowed = false
                completion(false)

            }
        }
    
    }
    
    
    
    
    
    
}

