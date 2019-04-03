//
//  FeedVC.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/14/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit
import Firebase
import ActiveLabel

private let reuseIdentifier = "Cell"

class FeedVC: UICollectionViewController,UICollectionViewDelegateFlowLayout , FeedCellDelegate {
    

    //MARK: - Properties
    
    var posts = [Post]()
    var viewSinglePost = false
    var post : Post?
    var currentKey : String?
    var userProfileController : UserProfileVC?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        // call Logout Buttton
        configureNavigationBar()

        // Register cell classes
        self.collectionView!.register(Feedcell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // configure refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        //fetch posts
        if !viewSinglePost {
            self.fetchPosts()
        }

        updateUserFeeds()

    }


    //  MARK: - UICollectionView Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let height = width + 8 + 40 + 8 + 50 + 60
        return CGSize(width: width, height: height)
    }
    

    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if posts.count > 4 {
            if indexPath.item == posts.count - 1 {
                self.fetchPosts()
            }
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if viewSinglePost{
            
            return 1
        }
        else {
            
            return posts.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Feedcell
        
        cell.delegate = self
        
        if viewSinglePost {
            if let post = self.post {
                cell.post = post
            }
        }   else {
                cell.post = posts[indexPath.item]
            }
        
        handleHashtagTapped(forCell: cell)
        handleUserNameLabelTapped(forCell: cell)
        handleMentionedTapped(forCell: cell)
  
        return cell
    }
    
    //  MARK: - Feed Cell Delegates
    
    func handleUserNameTappe(for cell: Feedcell) {
        
        guard let post = cell.post else {return}
        
        let userProfileVC = UserProfileVC(collectionViewLayout : UICollectionViewFlowLayout())
        
        userProfileVC.user = post.user
        
        navigationController?.pushViewController(userProfileVC, animated: true)
        
        
    }
    
    func handleOptionsTapped(for cell: Feedcell) {
        
        guard let post = cell.post else {return}
        
        if post.ownerUid == Auth.auth().currentUser?.uid {
            
            let alerController = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
            
            alerController.addAction(UIAlertAction(title: "Delete Post", style: .destructive, handler: { (_) in
                //Delete post
                
                post.deletePost()
                
                if !self.viewSinglePost {
                    
                    self.handleRefresh()
                }
                    
                else {
                    
                    if let userProfileController = self.userProfileController {
                        
                        _ = self.navigationController?.popViewController(animated: true)
                        userProfileController.handleRefresh()
                    }
                }
                
            }))
            
            alerController.addAction(UIAlertAction(title: "Edit post", style: .default, handler: { (_) in
                
                let uploadPostController = UploadPostVC()
                let navigationController = UINavigationController(rootViewController: uploadPostController)
                uploadPostController.postToEdit = post
                uploadPostController.uploadAction = UploadPostVC.UploadAction(index: 1)
                self.navigationController?.pushViewController(uploadPostController, animated: true)
                self.present(navigationController, animated: true, completion: nil)
                
            }))
            
            alerController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alerController, animated: true, completion: nil)
            
            } else {
            
            let alerController = UIAlertController(title: "Cancel", message: nil, preferredStyle: .actionSheet)
            alerController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alerController, animated: true, completion: nil)
        }
    }
    
    func handleLikeTapped(for cell: Feedcell , isDoubleTapped : Bool) {
 
        guard let post = cell.post else {return}
        
        if post.didLike {
            //handle unlike a post
            if !isDoubleTapped {
                post.adjustLikes(addLike: false) { (likes) in
                    cell.likesLabel.text = "\(likes) likes"
                    cell.likeButton.setImage(UIImage(named: "like_unselected"), for: .normal)
                    cell.likeButton.tintColor = .black
                    
                }
            }
            
        } else {
            //handle liking post
            post.adjustLikes(addLike: true) { (likes) in
                cell.likesLabel.text = "\(likes) likes"
                cell.likeButton.setImage(UIImage(named: "like_selected"), for: .normal)
                cell.likeButton.tintColor = .red
            }
        }
    }
    
    
    func handleShowLikes(for cell: Feedcell) {
        
        guard let post = cell.post else {return}
        guard let postId = post.postId else {return}
        let followLikeVC = FollowLikeVC()
        followLikeVC.postId = postId // passing the value to followVC 
        followLikeVC.viewingMode = FollowLikeVC.ViewingMode(index: 2) // set the enum case value for followLikeVC
        navigationController?.pushViewController(followLikeVC, animated: true)
    }
    
    
    
    
    func handleConfigureLikeButton(for cell : Feedcell) {
        guard let currenUid = Auth.auth().currentUser?.uid else {return}
        guard let post = cell.post else {return}
        guard let postId = post.postId else {return}
        
        
        USER_LIKES_REF.child(currenUid).observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.hasChild(postId) {
                
                post.didLike = true
                cell.likeButton.setImage(UIImage(named: "like_selected"), for: .normal)
                cell.likeButton.tintColor = .red
                
            } else {
                post.didLike = false
                cell.likeButton.setImage(UIImage(named: "like_unselected"), for: .normal)
                cell.likeButton.tintColor = .black
                
            }
        }
        
    }

    
    func handleCommentTapped(for cell: Feedcell) {
        
        guard let post = cell.post else {return}
        let commentVC = CommentVC(collectionViewLayout : UICollectionViewFlowLayout())
        commentVC.post = post
        navigationController?.pushViewController(commentVC, animated: true)

    }
    

    // MARK: - Handlers
    
    @objc func handleRefresh(){
        posts.removeAll(keepingCapacity: false)
        self.currentKey = nil
        fetchPosts()
        collectionView.reloadData()
    }
    
    
    @objc func handleShowMessages() {
        
        let messagesController = MessagesController()
        navigationController?.pushViewController(messagesController, animated: true)
        
    }
    
    func handleHashtagTapped(forCell cell :Feedcell){
        
        cell.captionLabel.handleHashtagTap { (hashTag) in
            
            let hashtagController = HashtagController(collectionViewLayout: UICollectionViewFlowLayout())
            hashtagController.hashtag = hashTag
            self.navigationController?.pushViewController(hashtagController, animated: true)
        }
    }
    
    func handleMentionedTapped (forCell cell : Feedcell){
        
        cell.captionLabel.handleMentionTap { (username) in
            self.getMentionedUser(WithUserName: username)
        }
    }
    
    func handleUserNameLabelTapped(forCell cell : Feedcell) {
        
        guard let user = cell.post?.user else {return}
        guard let userName = user.userName else {return}
        
        let customType = ActiveType.custom(pattern: ("^\(userName)\\b"))
        
        cell.captionLabel.handleCustomTap(for: customType) { (_) in
            let userProfileController = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
            userProfileController.user = user
            self.navigationController?.pushViewController(userProfileController , animated: true)
        }
    }
    
    func configureNavigationBar(){
        
        if !viewSinglePost {
            
              self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogOut))
        }
      
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "send2"), style: .plain, target: self, action: #selector(handleShowMessages))
        
        self.navigationItem.title = "Feed"
    }
    
    @objc func handleLogOut(){
        
        //declare Allert controller
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        //dd alert logout action
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do {
                //attempt sign out
                try Auth.auth().signOut()
                
                //present Login VC
                let navController = UINavigationController(rootViewController: LoginVC())
                self.present(navController, animated: true, completion: nil)
                print("Succesfully Logged Out")
                
            } catch {
                //Handle Error
            print("Error in signing out with error",error.localizedDescription)
            }
        }))
        
        //add cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        //presennt alert controller
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: - API
    
    func updateUserFeeds(){

        //update with following people's post
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        USER_FOLLOWING_REF.child(currentUid).observe(.childAdded) { (snapshot) in
            
            let followingUserId = snapshot.key
            
            USER_POSTS_REF.child(followingUserId).observe(.childAdded, with: { (snapshot) in
                
                let postId = snapshot.key
                
                USER_FEED_REF.child(currentUid).updateChildValues([postId : 1])
            })
        }
        
        //update with own posts
        
        USER_POSTS_REF.child(currentUid).observe(.childAdded) { (snapshot) in
            
            let postId = snapshot.key
            USER_FEED_REF.child(currentUid).updateChildValues([postId : 1])
            
        }
    }
    
    func fetchPosts(){
        guard let currenUid = Auth.auth().currentUser?.uid else {return}
        
        if currentKey == nil {
            
            USER_FEED_REF.child(currenUid).queryLimited(toLast: 5).observeSingleEvent(of: .value) { (snapshot) in
                
                self.collectionView.refreshControl?.endRefreshing()
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else {return}
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else {return}
                
                allObjects .forEach({ (snapshot) in
                    let postId = snapshot.key
                    self.fetchPost(withpostId: postId)
                })
                
                self.currentKey = first.key
            }
        } else {
            
            USER_FEED_REF.child(currenUid).queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 6).observeSingleEvent(of: .value) { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else {return}
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else {return}
                
               // self.collectionView.refreshControl?.endRefreshing()
                
                allObjects.forEach({ (snapshot) in
                    let postId = snapshot.key
                    if postId != self.currentKey {
                        self.fetchPost(withpostId: postId)
                    }
                })
                
                self.currentKey = first.key
            }
        }
    }
    
    func fetchPost(withpostId postId : String){
        
        Database.fetchPost(with: postId) { (post) in
            self.posts.append(post)
            self.posts.sort(by: { (post1, post2) -> Bool in
                return post1.creationDate > post2.creationDate
            })
            
            self.collectionView.reloadData()
        }
    }
}
