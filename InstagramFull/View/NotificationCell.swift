//
//  NotificationCell.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 3/2/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    //  MARK: - Properties
    
    var delegate : NotificationCellDelegate?
    
    var notification : Notification? {
        
        didSet {
            
            guard let user = notification?.user else {return}
            guard let profileImageUrl = user.profileImageURL else {return}
            
            
            //Configure notification labels
            self.configureNotificationLabel()
            
            
            //Configre notification Type
            configureNotificationType()
            
            profileImageView.loadImage(with: profileImageUrl)
            
            if let post = notification?.post {
                
                postImageView.loadImage(with: post.imageUrl)
            }
            
        }
    }
    
    let profileImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        
        return iv
    }()
    
    let notificationlabel : UILabel = {
        let label = UILabel()

        
        label.numberOfLines = 2
        
        return label
    }()
    
    lazy var followButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("loading", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var postImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        let postTap = UITapGestureRecognizer(target: self, action: #selector(handlePostTapped))
        postTap.numberOfTapsRequired = 1
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(postTap)
        
        return iv
    }()
    
    
    
    //  MARK: - Handlers
    
    @objc func handlePostTapped(){
        delegate?.handlePostTapped(for: self)
        
    }
    
    @objc func handleFollowTapped(){
        
    delegate?.followTapped(for: self)
        
    }
    
    func configureNotificationLabel(){
        
        guard let notification = self.notification else {return}
        guard let user = notification.user else {return}
        guard let userName = user.userName else {return}
        guard let notificationMessage = notification.notofocationType?.description else {return}
        guard let notificationDate = self.getNotifocationTimeStamp() else {return}

        
        let attributedText = NSMutableAttributedString(string: "\(userName)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: notificationMessage, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]))
        attributedText.append(NSAttributedString(string: " \(notificationDate)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : UIColor.lightGray.cgColor]))
        
        notificationlabel.attributedText = attributedText
        
    }
    
    func configureNotificationType(){
        
        guard let notification = self.notification else {return}
        guard let user = notification.user else {return}
        
        var anchor : NSLayoutXAxisAnchor!
        
        if notification.notofocationType != .Follow {
            
            //Notification type is comment/Like
            addSubview(postImageView)
            postImageView.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 40, height: 40)
            postImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            anchor =  postImageView.leftAnchor
            
        } else {
            
            //notification type is Follow
            addSubview(followButton)
            followButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 90, height: 30)
            followButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            followButton.layer.cornerRadius = 3
            anchor = followButton.leftAnchor
            
            user.chekIfUserIsFollowed { (followed) in
                if followed {
                    
                    //Config Follow button for followed user
                    self.followButton.setTitle("Following", for: .normal)
                    self.followButton.setTitleColor(.black, for: .normal)
                    self.followButton.layer.borderWidth = 0.5
                    self.followButton.layer.borderColor = UIColor.lightGray.cgColor
                    self.followButton.backgroundColor = .white
                } else {
                    //config follow button for non-followed user
                    self.followButton.setTitle("Follow", for: .normal)
                    self.followButton.setTitleColor(.white, for: .normal)
                    self.followButton.layer.borderWidth = 0
                    self.followButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
                }
            }
        }
        addSubview(notificationlabel)
        notificationlabel.anchor(top: nil, left: profileImageView.rightAnchor, bottom: nil, right: anchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        notificationlabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func getNotifocationTimeStamp() -> String?{
        
        guard let notification = self.notification else { return nil }
        
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.allowedUnits = [.second , .minute , .hour , .day , .weekOfMonth]
        dateFormatter.maximumUnitCount = 1
        dateFormatter.unitsStyle = .abbreviated
        let now = Date()
        return dateFormatter.string(from: notification.creationDate, to: now)
        
    }
    
    
    //  MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style : style , reuseIdentifier : reuseIdentifier)
        
        self.selectionStyle = .none
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 40/2
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
