//
//  ChatCell.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 3/23/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit

class Chatcell : UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
