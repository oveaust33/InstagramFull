//
//  UserProfileHeader.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/15/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    var delegate : UserProfileHeaderDelegate?

    
    // MARK: - Properties
    
    var user : User? {
       
        didSet {
            
            //configure edit profile button
            configureEditprofileFollowButton()
            
            //set User Stats
            setUserStats(for: user)
            
            //showing the name under the profie photo
            let fullname = user?.name
            nameLabel.text = fullname
            
            guard let profileImageURL = user?.profileImageURL else {return}
            
            //loading the image in the profile photo
            profileImageView.loadImage(with: profileImageURL)
        }
        
    }
    
    let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        
        return iv
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        
        return label
    }()
    
    let postLabel : UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "5\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray.cgColor]))
        label.attributedText = attributedText
        
        
        return label
    }()
    
    lazy var followersLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        
        let attributedText = NSMutableAttributedString(string: " \n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray.cgColor]))
        label.attributedText = attributedText
        
        //add gesture recognizer
        
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        followTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        
        
        
        return label
    }()
    
    lazy var follwingLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        
        let attributedText = NSMutableAttributedString(string: " \n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray.cgColor]))
        label.attributedText = attributedText
        
        //add gesture recognizer
        
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        followTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        
        
        
        return label
    }()
    
    lazy var editProfileFollowButton : UIButton = {
        
        let button = UIButton(type : .system)
        button.setTitle("Loading", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        

        
        return button
    }()
    
    let gridButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        
        return button
    }()
    
    let listButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)

        
        return button
    }()
    
    let bookmarkButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)

        
        return button
    }()

    

    
    //MARK: - HANDLERS
    
    @objc func handleFollowingTapped(){
        
        delegate?.handleFollowingTapped(for: self)
    }
    
    
    @objc func handleFollowersTapped(){
        delegate?.handleFollowerTapped(for: self)
    }
    
    func configureBottomToolbar(){
        let topDividerView = UIView()
        topDividerView.backgroundColor = .lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = .lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton , listButton , bookmarkButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        
        stackView.anchor(top: nil, left: leftAnchor, bottom: self.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    func configureUserStats(){
        let stackView = UIStackView(arrangedSubviews: [postLabel , followersLabel , follwingLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
                stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
    }
    
    func setUserStats(for user : User?) {

        delegate?.setUserStats(for: self)

    }
    
    func configureEditprofileFollowButton(){
        guard let currentId = Auth.auth().currentUser?.uid else {return}
        guard let user = self.user else {return}
        
        if currentId == user.uid {
            
            //configure button as edit profile
            editProfileFollowButton.setTitle("Edit Profile", for: .normal)
            
        }
        
        else {
            
            //Configure button as follows
            editProfileFollowButton.setTitleColor(.white, for: .normal)
            editProfileFollowButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
            
            user.chekIfUserIsFollowed { (followed) in
                if followed {
                    
                        self.editProfileFollowButton.setTitle("Following", for: .normal)
                }
                    
                else {
                        self.editProfileFollowButton.setTitle("Follow", for: .normal)
                }
            }
        }
    }
    
 
    
    @objc func handleEditProfileFollow() {
        
        delegate?.handleEditFollowTapped(for: self)
        
    }
    
    
    // MARK: - Initialization
    
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 12 , paddingBottom: 0, paddingRight: 0, width: 80 , height: 80)
        profileImageView.layer.cornerRadius = 80/2
        
        addSubview(nameLabel)
        
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: nil , bottom: nil, right: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        nameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        
        configureUserStats()
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: postLabel.bottomAnchor, left: postLabel.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 18, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 30)
        
        configureBottomToolbar()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
