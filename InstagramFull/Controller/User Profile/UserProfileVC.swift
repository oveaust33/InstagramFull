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
    
    
    //MARK : -Properties
    
    var user : User?
    var posts = [Post]()
    var currentKey : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(UserPostCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        self.collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        

        
        //change Background color
        self.collectionView.backgroundColor = .white
        
        if self.user == nil {
            fetchUserCurrentData()
        }
        
        //fetch posts
        fetchPost()
        


    }
    
    // MARK: - UICollectionView FlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // Profile UI header size and width
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2)/3
        return CGSize(width: width, height: width)
    }
    
    

    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
        if posts.count > 9 {
            
            if indexPath.item == posts.count - 1{
                
                self.fetchPost()
            }
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
    }
    

    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // declare header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath ) as! UserProfileHeader
        
        //Set delegate
        
        header.delegate = self
        
        //set the user in header
        
        header.user = self.user
        navigationItem.title = user?.userName
        
        
        return header
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserPostCell
    
        // Configure the cell
        
        cell.post = posts[indexPath.item]
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let feedVC = FeedVC(collectionViewLayout : UICollectionViewFlowLayout())
        feedVC.viewSinglePost = true
        
        feedVC.post = posts[indexPath.item]
        
        navigationController?.pushViewController(feedVC, animated: true)
   
    }
    
    
    //  MARK: - UserProfileHeader Protocol
    
    func handleFollowerTapped(for header : UserProfileHeader){
        
        let followVC = FollowLikeVC()
        followVC.viewingMode = FollowLikeVC.ViewingMode(index: 1) //set the enum case index 1
        followVC.uid = user?.uid
        navigationController?.pushViewController(followVC, animated: true)
        
    }
    
    func handleFollowingTapped(for header: UserProfileHeader) {
        let followVC = FollowLikeVC()
        followVC.viewingMode = FollowLikeVC.ViewingMode(index: 0) //set the enum case index 0
        followVC.uid = user?.uid
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
        var numberofPosts : Int!
        
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
        
        //number of posts
        USER_POSTS_REF.child(uid).observe(.value) { (snapshot) in
            
            if let snapshot = snapshot.value as? Dictionary<String , AnyObject> {
                numberofPosts = snapshot.count
            }
            else {
                numberofPosts = 0
            }
            
            let attributedText = NSMutableAttributedString(string: "\(numberofPosts ?? 5)\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray.cgColor]))
            header.postLabel.attributedText = attributedText
            
        }
    }
    
    
    
    
    
    //  MARK: - API
    
    func fetchPost() {
        
        var uid : String!
        
        if let user = self.user {
            uid = user.uid
        } else {
            
            uid = Auth.auth().currentUser?.uid
        }
        
        //initial data full
        if currentKey == nil {
            
            USER_POSTS_REF.child(uid).queryLimited(toLast: 10).observeSingleEvent(of: .value) { (snapshot) in
                
                self.collectionView.refreshControl?.endRefreshing()
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else {return}
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else {return}
                
                allObjects.forEach({ (snapshot) in
                    
                    let postId = snapshot.key
                    self.fetchPost(withPostId: postId)
                })
                
                self.currentKey = first.key
            }
        } else {
            
            USER_POSTS_REF.child(uid).queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 7).observeSingleEvent(of: .value) { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else {return}
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else {return}
                
                allObjects.forEach({ (snapshot) in
                    let postId = snapshot.key
                    if postId != self.currentKey {
                        self.fetchPost(withPostId: postId)
                    }
                })
                
                self.currentKey = first.key
            }
        }
    }
    
    

    func fetchPost(withPostId postId: String){
        
        Database.fetchPost(with: postId) { (post) in
            self.posts.append(post)
            self.posts.sort(by: { (post1, post2) -> Bool in
                return post1.creationDate > post2.creationDate
            })
            
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserCurrentData(){
        
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("users").child(currentUID).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary <String , AnyObject> else {return}
            let user = User(uid: currentUID, dictionary: dictionary)
            self.user = user
            self.navigationItem.title = user.userName
            self.collectionView.reloadData()
        }
    }
}
