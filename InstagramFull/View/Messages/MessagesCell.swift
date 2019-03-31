//
//  MessagesCell.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 3/22/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit
import Firebase

class MessagesCell: UITableViewCell {
    
    //  MARK: - Properties
    
    var message : Message? {
        
        didSet{
            
            guard let messageText = message?.messageText else {return}
            detailTextLabel?.text = messageText
            
            if let seconds = message?.creationDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                timeStampLabel.text = dateFormatter.string(from: seconds)
            }
            
            configureUserdata()
            
        }
    }
    
    let profileImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        
        return iv
    }()
    
    let timeStampLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.text = "2 Hours"
        
        return label
        
    }()
    
    
    
    
    //  MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImageView.layer.cornerRadius = 50/2
        
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(timeStampLabel)
        timeStampLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        textLabel?.text = "Joker"
        detailTextLabel?.text = "fwefnw kjnbuwbdvkj dvbdbvkbwdbv"
        
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 68, y: (textLabel?.frame.origin.y)! - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        detailTextLabel?.frame = CGRect(x: 68, y: (detailTextLabel?.frame.origin.y)! + 2, width: self.frame.width - 100, height: (detailTextLabel?.frame.height)!)
        textLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        detailTextLabel?.textColor = .lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  MARK: - Handlers
    
    func configureUserdata(){
        guard let chatPartnerId = message?.getChatPartnerId() else {return}
        Database.fetchUser(with: chatPartnerId) { (user) in
            
            self.profileImageView.loadImage(with: user.profileImageURL)
            self.textLabel?.text = user.userName
        }
    }
}
