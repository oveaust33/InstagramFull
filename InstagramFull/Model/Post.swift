//
//  Post.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/21/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import Foundation
class Post {
    
    //  MARK: - Attributes
    
    var caption : String!
    var likes : Int!
    var imageUrl : String!
    var ownerUid : String!
    var creationDate : Date!
    var postId : String!
    
    init(postId : String! , dictionary : Dictionary<String , AnyObject>) {
        
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
    
    
    
}
