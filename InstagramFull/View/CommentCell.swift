//
//  CommentCell.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 3/1/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    var comment : Comment? {
        
        didSet {
            guard let user = comment?.user else {return}
            guard let profileImageUrl = comment?.user?.profileImageURL else {return}
            guard let userName = user.userName else {return}
            guard let commentText = comment?.commentText else {return}
            guard let commentTime = self.getCommentTimeStamp() else {return}
            
            profileImageView.loadImage(with: profileImageUrl)
            
            let attributedText = NSMutableAttributedString(string: userName , attributes: [NSMutableAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSMutableAttributedString(string: " \(commentText)", attributes: [NSMutableAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
            
            attributedText.append(NSMutableAttributedString(string: " \(commentTime)", attributes: [NSMutableAttributedString.Key.font : UIFont.systemFont(ofSize: 14) , NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
            
            commentTextView.attributedText = attributedText
 
        }
    }
    
  
    
    let profileImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        
        return iv
        
    }()
    
    let commentTextView : UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.isScrollEnabled = false
        
        return tv
    }()
    
    func getCommentTimeStamp() -> String?{
        
        guard let comment = self.comment else { return nil }
        
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.allowedUnits = [.second , .minute , .hour , .day , .weekOfMonth]
        dateFormatter.maximumUnitCount = 1
        dateFormatter.unitsStyle = .abbreviated
        let now = Date()
        return dateFormatter.string(from: comment.creationDate, to: now)
        
    }

    override init(frame: CGRect) {
        super.init(frame : frame)
        
        addSubview(profileImageView)
        
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40 , height: 40)
        
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        profileImageView.layer.cornerRadius = 40/2
        
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 0)
       
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
