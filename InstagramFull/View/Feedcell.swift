//
//  Feedcell.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/23/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit
import Firebase


class Feedcell: UICollectionViewCell {
    
    //  MARK: - properties
    
    var delegate : FeedCellDelegate?
    
    var post :Post? {
        
        didSet {
            
            guard let ownerUid = post?.ownerUid else {return}
            guard let imageUrl = post?.imageUrl else {return}
            guard let likes = post?.likes else {return}
            
            Database.fetchUser(with: ownerUid) { (user) in
                
                self.profileImageView.loadImage(with: user.profileImageURL)
                self.userNameButton.setTitle(user.userName, for: .normal)
                self.configurePostCaption(user: user)
            }
            
            self.postImageView.loadImage(with: imageUrl)
            self.likesLabel.text = ("\(likes) likes")
            
            configureLikeButton()

        }
        
    }
    
    
    let profileImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        
        return iv
    }()
    
    lazy var userNameButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("username", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleUserNameTapped), for: .touchUpInside)
        
        return button
        
    }()
    
    lazy var optionsButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleOptionsTapped), for: .touchUpInside)
        
        return button
 
    }()
    
    lazy var postImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        
        //add gesture recognizer to douvle tap like
        let liketap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapToLike))
        liketap.numberOfTapsRequired = 2
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(liketap)
   
        return iv
    }()
    
    lazy var likeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like_unselected"), for: .normal)
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        button.tintColor = .black
        
        return button
        
    }()
    
    lazy var commentButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        button.tintColor = .black
        
        return button
        
    }()
    
    let messageButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "send2"), for: .normal)
        button.tintColor = .black
        
        return button
        
    }()
    
    let savePostButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    lazy var likesLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .black
        label.text = "3 Likes"
        
        //add gesture recognizer
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleShowLikes))
        likeTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(likeTap)
        
        
        return label
    }()
    
    let captionLabel : UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "username ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: "Some text caption for now", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]))
        label.attributedText = attributedText
        
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "2 days ago"
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame : frame)
   
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft:8, paddingBottom: 0, paddingRight: 0, width: 45, height: 45)
        profileImageView.layer.cornerRadius = 45/2
        
        
        addSubview(userNameButton)
        userNameButton.anchor(top: nil, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        userNameButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        
        addSubview(optionsButton)
        optionsButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        optionsButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        
        addSubview(postImageView)
        postImageView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        //call StackView
        configureActionButton()
        
        addSubview(savePostButton)
        savePostButton.anchor(top: postImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 20, height: 24)
        
        addSubview(likesLabel)
        likesLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: -4, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: likesLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        addSubview(timeLabel)
        timeLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        
    }
    
    //  MARK: - Handlers
    
    @objc func handleDoubleTapToLike(){
        
        delegate?.handleLikeTapped(for: self, isDoubleTapped: true)
        
        
    }
    
    @objc func handleUserNameTapped(){
        
        delegate?.handleUserNameTappe(for: self)
    
    }
    
    @objc func handleOptionsTapped(){
        
        delegate?.handleOptionsTapped(for: self)
        
    }
    
    @objc func handleLikeTapped(){
        
        delegate?.handleLikeTapped(for: self , isDoubleTapped : false)
        
    }
    
    @objc func handleCommentTapped(){
        
        delegate?.handleCommentTapped(for: self)
        
    }
    
    @objc func handleShowLikes(){
        
        delegate?.handleShowLikes(for: self)
        
    }
    
    func configureLikeButton(){
        delegate?.handleConfigureLikeButton(for: self)
        
    }
    
    func configurePostCaption(user: User) {
        
        guard let post = self.post else {return}
        guard let caption = post.caption else {return}
        
        let attributedText = NSMutableAttributedString(string: user.userName , attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: " \(caption)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]))
        
        captionLabel.attributedText = attributedText
        
        
    }
    
    func configureActionButton(){
        
        let stackView = UIStackView(arrangedSubviews: [likeButton , commentButton , messageButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: postImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 50)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
