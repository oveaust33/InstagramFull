//
//  UploadPostVC.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/20/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit
import Firebase

class UploadPostVC: UIViewController , UITextViewDelegate {
    
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
        button.addTarget(self, action: #selector(handleSharePost), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        captionTextView.delegate = self
        
        view.backgroundColor = .white
        
        //configure View Components
        configureViewComponents()
        
        //load image
        loadImage()

    }
    
    //  MARK: - UITextView
    
    func textViewDidChange(_ textView: UITextView) {
        
        guard !textView.text.isEmpty else {
            
            shareButton.isEnabled = false
            shareButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            return
        }
        
        shareButton.isEnabled = true
        shareButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)

    }
    
    //  MARK: - Handlers
    
    @objc func handleSharePost(){
        
        //parameters
        
        guard
            let caption = captionTextView.text ,
            let postImage = photoImageView.image ,
            let currentUid = Auth.auth().currentUser?.uid else {return}
        
        //Creation Date
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        //Image Upload data
        guard let uploadData = postImage.jpegData(compressionQuality: 0.5) else {return}
      
        //update Storege
        let fileName = NSUUID().uuidString
        
        //in order to get Download URLmust add filename to storage REF
        let storageRef = Storage.storage().reference().child("post_images").child(fileName)
        
        //image URL
        storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
            
            //handle error
            if let error = error {
                print("Failed to upload image to firebase with error", error.localizedDescription)
                return
            }
            
            //success
            storageRef.downloadURL(completion: { (downloadURL, error) in
                guard let postImageUrl = downloadURL?.absoluteString else {
                    print("Debug : Profile Image URL is nil")
                    return
                }
                
            //post Data
            let values =    ["caption"        : caption      ,
                              "creationDate"  : creationDate ,
                              "likes"         : 0            ,
                              "imageUrl"      : postImageUrl ,
                              "ownerUid"      : currentUid]    as [String : Any]
                
                //post id
                let postId = POSTS_REF.childByAutoId()
                
                guard let postKey = postId.key else { return }
                
                //update USER-POST structure
                USER_POSTS_REF.child(currentUid).updateChildValues([postKey : 1])
                
                //upload info to database
                postId.updateChildValues(values, withCompletionBlock: { (error, ref) in
                    

                    //return to homeFeed
                    self.dismiss(animated: true, completion: {
                        self.tabBarController?.selectedIndex = 0
                    })
                })
                
                
            })
        })
    }
    
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
