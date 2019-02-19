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
    
    func handleFollowTapped(for cell : FollowCell )
}
