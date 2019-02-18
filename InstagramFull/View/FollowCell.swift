//
//  FollowCell.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/19/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit

class FollowCell: UITableViewCell {
    
    //  MARK: - Properties
    
    let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        
        
        return iv
        
    }()
    
    lazy var followButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("loading", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    }()
    
    //  MARK: - Handlers
    
    @objc func handleFollowTapped(){
        print("Handle follow tapped here....")
    }
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style : .subtitle , reuseIdentifier : reuseIdentifier)
        
        addSubview(profileImageView)
        
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 48, height: 48)
        
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        profileImageView.layer.cornerRadius = 48/2
        
        addSubview(followButton)
        followButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 90, height: 30)
        
        followButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        followButton.layer.cornerRadius = 3
        
        
        self.textLabel?.text = "Username"
        self.detailTextLabel?.text = "Full Name"

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 68, y: textLabel!.frame.origin.y - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        detailTextLabel?.frame = CGRect(x: 68, y: detailTextLabel!.frame.origin.y, width: self.frame.width - 108, height: detailTextLabel!.frame.height)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        detailTextLabel?.textColor = .lightGray

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
