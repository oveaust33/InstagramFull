//
//  Constants.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/17/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import Firebase


//ROOT : REFFERENCES
let DB_REF = Database.database().reference()
let STORAGE_REF = Storage.storage().reference()

// MARK : DATABASE REFFERENCES

let USER_REF = DB_REF.child("users")

let USER_FOLLOWER_REF = DB_REF.child("user-followers")
let USER_FOLLOWING_REF = DB_REF.child("user-following")



