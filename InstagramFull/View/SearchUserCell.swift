//
//  SearchUserCell.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/16/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit

class SearchUserCell: UITableViewCell {
    
    //Mark : Properties
    var user : User? {
        
        didSet {
            
            guard let profileImageURL = user?.profileImageURL else {return}
            guard let userName = user?.userName else {return}
            guard let fullName = user?.name else {return}
            
            profileImageView.loadImage(with: profileImageURL)
            self.textLabel?.text = userName
            self.detailTextLabel?.text = fullName

        }
        
    }
    
    let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style : .subtitle , reuseIdentifier : reuseIdentifier)
        
        //add profile imageview
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 48, height: 48)
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 48/2
        profileImageView.clipsToBounds = true
        
        //showing name and sub title
        self.textLabel?.text = "username"
        self.detailTextLabel?.text = "full Name"
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 68, y: (textLabel?.frame.origin.y)! - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        detailTextLabel?.frame = CGRect(x: 68, y: (detailTextLabel?.frame.origin.y)! - 2, width: (self.frame.width) - 108, height: (detailTextLabel?.frame.height)!)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        detailTextLabel?.textColor = .lightGray


    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}