//
//  UserProfileVC.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/14/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"
private let headerIdentifier = "UserProfileHeader"

class UserProfileVC: UICollectionViewController , UICollectionViewDelegateFlowLayout , UserProfileHeaderDelegate  {
    
    
    //MARK : Properties
    
    var currentUser : User?
    var userToLoadFromSearchVC : User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        self.collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        

        
        //change Background color
        self.collectionView.backgroundColor = .white
        
        if userToLoadFromSearchVC == nil {
            fetchUserCurrentData()
        }
        


    }

    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }
    
    // Profile UI header size and width
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // declare header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath ) as! UserProfileHeader
        
        //Set delegate
        
        header.delegate = self
        
        //set the user in header
        if let user = self.currentUser {
            header.user = user
        }
        else if let userToLoadFromSearchVC = self.userToLoadFromSearchVC {
        
            header.user = userToLoadFromSearchVC
            navigationItem.title = userToLoadFromSearchVC.userName
        }
        
        return header
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        
        
    
        return cell
    }
    
    
    //  MARK: - UserProfileHeader Protocol
    
    func handleFollowerTapped(for header : UserProfileHeader){
        
        let followVC = FollowVC()
        followVC.viewFollowers = true
        
        navigationController?.pushViewController(followVC, animated: true)
        
    }
    
    func handleFollowingTapped(for header: UserProfileHeader) {
        let followVC = FollowVC()
        followVC.viewFollowing = true
        navigationController?.pushViewController(followVC, animated: true)
    }
    
    
    
    func handleEditFollowTapped(for header: UserProfileHeader) {
        
        guard let user = header.user else {return}
        
        if header.editProfileFollowButton.titleLabel?.text == "Edit Profile" {
            print ("Handle Edit Profile")
        } else {
            if header.editProfileFollowButton.titleLabel?.text == "Follow" {
                
                header.editProfileFollowButton.setTitle("Following", for: .normal)
                user.follow()
                
            } else  {
                
                header.editProfileFollowButton.setTitle("Follow", for: .normal)
                user.unfollow()
            }
        }

    }
    
    func setUserStats(for header: UserProfileHeader) {
        
        guard let uid = header.user?.uid else {return}
        
        var numberOfFollowers : Int!
        var numberOfFollowing : Int!
        
        //  Get number of FOLLOWERS
        USER_FOLLOWER_REF.child(uid).observe(.value) { (snapshot) in
            if let snapshot = snapshot.value as? Dictionary<String , AnyObject> {
                numberOfFollowers = snapshot.count
            }
            else {
                numberOfFollowers = 0
            }
            
            let attributedText = NSMutableAttributedString(string: "\(numberOfFollowers ?? 5)\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray.cgColor]))
            header.followersLabel.attributedText = attributedText
        }
        
        
        //  Number Of following
        
        USER_FOLLOWING_REF.child(uid).observe(.value) { (snapshot) in
            if let snapshot = snapshot.value as? Dictionary<String , AnyObject> {
                numberOfFollowing = snapshot.count
            }
            else {
                numberOfFollowing = 0
            }
            
            let attributedText = NSMutableAttributedString(string: "\(numberOfFollowing ?? 5)\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray.cgColor]))
            header.follwingLabel.attributedText = attributedText
            
        }
    }
    
    
    //MARK : API
    
    func fetchUserCurrentData(){
        
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("users").child(currentUID).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary <String , AnyObject> else {return}
            let user = User(uid: currentUID, dictionary: dictionary)
            self.currentUser = user
            self.navigationItem.title = user.userName
            self.collectionView.reloadData()
        }
    }
}
