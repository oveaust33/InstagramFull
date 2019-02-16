//
//  User.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/15/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

class User {
    
    //Attributes
    var userName : String!
    var name : String!
    var profileImageURL : String!
    var uid : String!
    
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
    
    
    
    
}
