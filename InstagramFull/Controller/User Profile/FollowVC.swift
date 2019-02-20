//
//  FollowVC.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/19/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "FollowCell"

class FollowVC : UITableViewController , FollowCellDelegate {

    
    //  MARK: - properties
    
    var viewFollowers = false
    var viewFollowing = false
    var uid : String?
    var users = [User]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(FollowCell.self, forCellReuseIdentifier: reuseIdentifier)
        navigationItem.title = "Followers"
        
        //configure Nav Controller
        if viewFollowers {
            navigationItem.title = "Followers"
        }
        else {
            navigationItem.title = "Following"
        }
        
        //clear Separator Line
        tableView.separatorColor = .clear
        
        fetchUsers()

    }
    
    
    
    //  MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier , for: indexPath) as! FollowCell
        cell.user = users[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let userProfileVC = UserProfileVC (collectionViewLayout : UICollectionViewFlowLayout())
        userProfileVC.user = user
        navigationController?.pushViewController(userProfileVC, animated: true)
   }
    
    
    //  MARK: - FollowCellDelegate protocol
    
    func handleFollowTapped(for cell: FollowCell) {
        
        guard let user = cell.user else {return}
        if user.isFollowed {
            
            user.unfollow()
            
            //config follow button for non-followed user
            cell.followButton.setTitle("Follow", for: .normal)
            cell.followButton.setTitleColor(.black, for: .normal)
            cell.followButton.layer.borderWidth = 0
            cell.followButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        }
            
        else {
            
            user.follow()
            //Config Follow button for followed user
            cell.followButton.setTitle("Following", for: .normal)
            cell.followButton.setTitleColor(.black, for: .normal)
            cell.followButton.layer.borderWidth = 0.5
            cell.followButton.layer.borderColor = UIColor.lightGray.cgColor
            cell.followButton.backgroundColor = .white
        }
    }
    
    
    //  MARK: - API
    
    func fetchUsers() {
        
        guard let uid = self.uid else {return}
        var ref : DatabaseReference!

        if viewFollowers {
            
            // Fetch Followers
            ref = USER_FOLLOWER_REF

            
        } else {
            
            //Fetch Following Users
            ref = USER_FOLLOWING_REF
        }
        
        ref.child(uid).observeSingleEvent(of : .value) { (snapshot) in
            
            guard let allobjects = snapshot.children.allObjects as? [DataSnapshot] else {return}
            
            allobjects.forEach({ (snapshot) in
                let userId = snapshot.key
                
                Database.fetchUser(with: userId, completion: { (user) in
                    self.users.append(user)
                    
                    self.tableView.reloadData()
                })

            })
 
        }
        
        
    }

}

