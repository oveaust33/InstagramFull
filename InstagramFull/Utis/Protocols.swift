//
//  Protocols.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/19/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import Foundation

protocol UserProfileHeaderDelegate {
    
    func handleEditFollowTapped(for header : UserProfileHeader)
    func setUserStats (for header : UserProfileHeader)
    func handleFollowerTapped(for header : UserProfileHeader)
    func handleFollowingTapped(for header : UserProfileHeader)
}

protocol FollowCellDelegate {
    
    func handleFollowTapped(for cell : FollowLikeCell )
}

protocol FeedCellDelegate {
    
    func handleUserNameTappe(for cell : Feedcell)
    func handleOptionsTapped(for cell : Feedcell)
    func handleLikeTapped(for cell : Feedcell , isDoubleTapped : Bool)
    func handleCommentTapped(for cell : Feedcell)
    func handleConfigureLikeButton(for cell : Feedcell)
    func handleShowLikes(for cell : Feedcell)
    
}

protocol NotificationCellDelegate {
    
    func followTapped (for cell : NotificationCell)
    func handlePostTapped (for cell : NotificationCell)
 
}

protocol Printable {
    var description : String { get }
}


