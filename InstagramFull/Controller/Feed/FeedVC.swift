//
//  FeedVC.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/14/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class FeedVC: UICollectionViewController,UICollectionViewDelegateFlowLayout , FeedCellDelegate {

    
    
    //MARK: - Properties
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        // call Logout Buttton
        configureNavigationBar()

        // Register cell classes
        self.collectionView!.register(Feedcell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //fetch posts
        fetchPosts()
        
        

    }

    //  MARK: - UICollectionView Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let height = width + 8 + 40 + 8 + 50 + 60
        return CGSize(width: width, height: height)
    }
    

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Feedcell
        cell.delegate = self
        cell.post = posts[indexPath.item]
        
        
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
        print("User options Tapped")

    }
    
    func handleLikeTapped(for cell: Feedcell) {
        print("User like Tapped")

    }
    
    func handleCommentTapped(for cell: Feedcell) {
        print("User comment Tapped")

    }
    

    // MARK: - Handlers
    
    
    @objc func handleShowMessages() {
        
        print("Handle Messages...")
    }
    
    func configureNavigationBar(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogOut))
        
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
    
    func fetchPosts(){
        
        POSTS_REF.observe(.childAdded) { (snapshot) in
            //print(snapshot) ALL posts in DATABASE
            
            let postId = snapshot.key
            
            Database.fetchPost(with: postId, completion: { (post) in
                self.posts.append(post)
                
                self.posts.sort(by: { (post1, post2) -> Bool in
                    return post1.creationDate > post2.creationDate
                })
                
                //print("post caption is  \(post.caption)\n")
                self.collectionView.reloadData()
            })
        }
    }
}
