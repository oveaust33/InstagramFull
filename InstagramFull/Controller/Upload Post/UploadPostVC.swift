//
//  UploadPostVC.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/20/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit

class UploadPostVC: UIViewController {
    
    //  Mark: - Properties
    
    var selectedImage : UIImage?
    
    let photoImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .red
        iv.layer.cornerRadius = 3
        iv.layer.masksToBounds = true
        
        return iv
    }()
    
    let captionTextView : UITextView = {
        let tv = UITextView()
        tv.backgroundColor = UIColor.groupTableViewBackground
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.layer.cornerRadius = 5
        tv.layer.masksToBounds = true
        
        return tv
    }()
    
    let shareButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.setTitle("Publish", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .white
        
        //configure View Components
        configureViewComponents()
        
        //load image
        loadImage()

    }
    
    //  MARK: - Handlers
    
    func configureViewComponents() {
        
        view.addSubview(photoImageView)
        photoImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 92, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: view.topAnchor, left: photoImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 92, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 100)
        
        view.addSubview(shareButton)
        shareButton.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 40)
        
    }
    
    func loadImage() {
        
        guard let selectedImage = self.selectedImage else {return}
        photoImageView.image = selectedImage
        
    }

}
