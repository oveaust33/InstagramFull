//
//  CommentCell.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 3/1/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit
import ActiveLabel

class CommentCell: UICollectionViewCell {
    
    var comment : Comment? {
        
        didSet {
            guard let user = comment?.user else {return}
            guard let profileImageUrl = comment?.user?.profileImageURL else {return}
            profileImageView.loadImage(with: profileImageUrl)
            
            configureCommentlabel()
 
        }
    }
    
  
    
    let profileImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        
        return iv
        
    }()
    
    let commentLabel : ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        
        return label
    }()
    

    
    //  MARK: - Init

    override init(frame: CGRect) {
        super.init(frame : frame)
        
        addSubview(profileImageView)
        
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40 , height: 40)
        
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        profileImageView.layer.cornerRadius = 40/2
        
        addSubview(commentLabel)
        commentLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 0)
       
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //  MARK: - Handlers
    
    func configureCommentlabel(){
        
        guard let user = comment?.user else {return}
        guard let userName = user.userName else {return}
        guard let commentText = comment?.commentText else {return}
        guard let comment = self.comment else {return}
        
        let customType = ActiveType.custom(pattern: "^\(userName)\\b")
        
        commentLabel.enabledTypes = [.hashtag , .mention , .url , customType]
        
        commentLabel.configureLinkAttribute = {(type , attributes , isSelected) in
            
            var atts = attributes
            switch type {
                
            case .custom : atts[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: 12)
            default :()
            }
            return atts
        }
        
        commentLabel.customize { (label) in
            label.text = "\(userName) \(commentText)"
            label.customColor[customType] = .black
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .black
            label.numberOfLines = 2
        }
    }
    
    func getCommentTimeStamp() -> String?{
        
        guard let comment = self.comment else { return nil }
        
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.allowedUnits = [.second , .minute , .hour , .day , .weekOfMonth]
        dateFormatter.maximumUnitCount = 1
        dateFormatter.unitsStyle = .abbreviated
        let now = Date()
        return dateFormatter.string(from: comment.creationDate, to: now)
    }
}
