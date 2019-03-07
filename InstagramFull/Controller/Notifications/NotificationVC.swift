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
    
    var timer : Timer?
    
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
            
            //Unfollow user
            user.unfollow()
            cell.followButton.configure(didFollow: false)
            
        } else {
            
            //Follow user
            user.follow()
            cell.followButton.configure(didFollow: true)
        }
    }
    
    func handlePostTapped(for cell: NotificationCell) {
        
        guard let post = cell.notification?.post else {return}
        let feedController = FeedVC(collectionViewLayout : UICollectionViewFlowLayout())
        feedController.viewSinglePost = true
        feedController.post = post
        navigationController?.pushViewController(feedController, animated: true)

    }
    
    //  MARK: - Handlers
    
    func handleReloadTable(){
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleSortNotification), userInfo: nil, repeats: false)
        
    }
    
    @objc func handleSortNotification(){
        
        self.notifications.sort { (notification1, notification2) -> Bool in
            
            return notification1.creationDate > notification2.creationDate
        }
        self.tableView.reloadData()
    }
    
    //  MARK: - API
    
     func fetchNotification(){
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        NOTIFICATIONS_REF.child(currentUid).observe(.childAdded) { (snapshot) in
            
            guard let dictionary = snapshot.value as? Dictionary<String,AnyObject> else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            let notificationId = snapshot.key  
            
            Database.fetchUser(with: uid, completion: { (user) in
                
                //if notification is for post like comment
                if let postId = dictionary["postId"] as? String {
                    
                    Database.fetchPost(with: postId, completion: { (post) in
                        
                        let notification = Notification(user: user, post: post, dictionary: dictionary)
                        self.notifications.append(notification)
                        self.handleReloadTable()
                    })
                    
                } else {
                    
                    let notification = Notification(user: user, dictionary: dictionary)
                    self.notifications.append(notification)
                    self.handleReloadTable()
                }
            })
            
            NOTIFICATIONS_REF.child(currentUid).child(notificationId).child("checked").setValue(1)

        }
    }
}
