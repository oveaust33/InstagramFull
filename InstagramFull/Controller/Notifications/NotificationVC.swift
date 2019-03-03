//
//  NotificationVC.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/14/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "NotificationCell"

class NotificationVC: UITableViewController, NotificationCellDelegate {

    
    //  MARK: - Properties
    
    var notifications = [Notification]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //clear seperator lines
        tableView.separatorColor = .clear
        
        //register Cell Class
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        //navigation title
        navigationItem.title = "Notification"
        
        //fetch notification
        fetchNotification()
        
        
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.notification = notifications[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        let userProfileVC = UserProfileVC(collectionViewLayout : UICollectionViewFlowLayout())
        userProfileVC.user = notification.user
        navigationController?.pushViewController(userProfileVC, animated: true)
        
    }
    
    // MARK: - notofocation cell delegate protocol
    
    func followTapped(for cell: NotificationCell) {
        
        guard let user = cell.notification?.user else {return}
        if user.isFollowed {
            
            user.unfollow()
            cell.followButton.setTitle("Follow", for: .normal)
            cell.followButton.setTitleColor(.white, for: .normal)
            cell.followButton.layer.borderWidth = 0
            cell.followButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
            
        } else {
            
            user.follow()
            cell.followButton.setTitle("Following", for: .normal)
            cell.followButton.setTitleColor(.black, for: .normal)
            cell.followButton.layer.borderWidth = 0.5
            cell.followButton.layer.borderColor = UIColor.lightGray.cgColor
            cell.followButton.backgroundColor = .white
        }
    }
    
    func handlePostTapped(for cell: NotificationCell) {
        
        guard let post = cell.notification?.post else {return}
        let feedController = FeedVC(collectionViewLayout : UICollectionViewFlowLayout())
        feedController.viewSinglePost = true
        feedController.post = post
        
        navigationController?.pushViewController(feedController, animated: true)

    }
    
    
    //  MARK: - API
    
    func fetchNotification(){
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        NOTIFICATIONS_REF.child(currentUid).observe(.childAdded) { (snapshot) in
            
            guard let dictionary = snapshot.value as? Dictionary<String,AnyObject> else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            
            Database.fetchUser(with: uid, completion: { (user) in
                
                //if notification is for post like comment
                if let postId = dictionary["postId"] as? String {
                    
                    Database.fetchPost(with: postId, completion: { (post) in
                        
                        let notification = Notification(user: user, post: post, dictionary: dictionary)
                        self.notifications.append(notification)
                        self.tableView.reloadData()
                    })
                    
                } else {
                    
                    let notification = Notification(user: user, dictionary: dictionary)
                    self.notifications.append(notification)
                    self.tableView.reloadData()
                }
                
            })
            
        }
    }

}
