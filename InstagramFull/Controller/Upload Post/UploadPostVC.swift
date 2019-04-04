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
    
    enum UploadAction {
        
        case uploadPost
        case saveChanges
        
        init(index : Int) {
            
            switch index {
            case 0 : self = .uploadPost
            case 1 : self = .saveChanges
            default : self = .uploadPost
                
            }
        }
    }
    
    var selectedImage : UIImage?
    var postToEdit : Post?
    var uploadAction : UploadAction!
    
    let photoImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 3
        iv.layer.masksToBounds = true
        
        return iv
    }()
    
    var activityIndicator : UIActivityIndicatorView = {
        
        let Activity = UIActivityIndicatorView()
        Activity.color = .green
        return Activity
    }()
    
    let captionTextView : UITextView = {
        let tv = UITextView()
        tv.backgroundColor = UIColor.groupTableViewBackground
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.layer.cornerRadius = 5
        tv.layer.masksToBounds = true
        
        return tv
    }()
    
    let actionButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.setTitle("Publish", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleUploadAction), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captionTextView.delegate = self
        
        view.backgroundColor = .white
        
        //configure View Components
        configureViewComponents()
        
        //load image
        loadImage()
        
        //activity indicator
        view.addSubview(activityIndicator)
        activityIndicator.isHidden = true
        activityIndicator.center = view.center

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if uploadAction == .saveChanges{
            
            guard let post = self.postToEdit else {return}
            actionButton.setTitle("Save Changes", for: .normal)
            self.navigationItem.title = "Edit Post"
            navigationController?.navigationBar.tintColor = .black
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
            photoImageView.loadImage(with: post.imageUrl)
            captionTextView.text = post.caption
            
        } else {
            
            self.navigationItem.title = "Upload Post"
            actionButton.setTitle("Share", for: .normal)
        }
    }
    
    //  MARK: - UITextView
    
    func textViewDidChange(_ textView: UITextView) {
        
        guard !textView.text.isEmpty else {
            
            actionButton.isEnabled = false
            actionButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            return
        }
        
        actionButton.isEnabled = true
        actionButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)

    }
    
    //  MARK: - Handlers
    
    @objc func handleCancel(){
        
        self.dismiss(animated: true, completion: nil)
    
    }
    
    func updateUserFeeds(with postId : String){
        
        // current user id
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        // database values
        let values = [postId : 1]
        
        //update follower feed
        USER_FOLLOWER_REF.child(currentUid).observe(.childAdded) { (snapshot) in
            let followerUid = snapshot.key
            USER_FEED_REF.child(followerUid).updateChildValues(values)
        }
        
        // update current user feed
        USER_FEED_REF.child(currentUid).updateChildValues(values)
        
    }
    
    @objc func handleUploadAction(){
        
        buttonSelector(uploadAction: uploadAction)
        
        
    }
    
    func buttonSelector(uploadAction : UploadAction){
        
        switch uploadAction {
 
        case .uploadPost:
            handleUploadPost()
        case .saveChanges:
            handleSavePostChanges()
        }
    }
    
    func handleSavePostChanges(){
        activityIndicator.isHidden = false
        guard let post = postToEdit else {return}
        guard let postId = post.postId else {return}
        //guard let postIdKey = POSTS_REF.childByAutoId().key else {return}
        let updatedCaption = captionTextView.text
        
        uploadHashtagToServer(withPostId: postId)
        
        POSTS_REF.child(postId).child("caption").setValue(updatedCaption) { (err, ref) in
            
            self.activityIndicator.startAnimating()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func handleUploadPost(){
        
        activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
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
                
                //                //update USER-POST structure
                //                USER_POSTS_REF.child(currentUid).updateChildValues([postKey : 1])
                //
                //                //update feed structure
                //                self.updateUserFeeds(with: postKey)
                
                //upload info to database
                postId.updateChildValues(values, withCompletionBlock: { (error, ref) in
                    
                    //update USER-POST structure
                    USER_POSTS_REF.child(currentUid).updateChildValues([postKey : 1])
                    
                    //update feed structure
                    self.updateUserFeeds(with: postKey)
                    
                    //upload hashtag to server
                    self.uploadHashtagToServer(withPostId: postKey)
                    
                    //upload mention notification to server
                    if caption.contains("@"){
                        self.uploadMentiondNotification(forPostId: postKey, withTextId: caption , isForComment: false)
                    }
                    
                    //return to homeFeed
                    self.dismiss(animated: true, completion: {
                        self.activityIndicator.stopAnimating()
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
        
        view.addSubview(actionButton)
        actionButton.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 40)
        
    }
    
    func loadImage() {
        
        guard let selectedImage = self.selectedImage else {return}
        photoImageView.image = selectedImage
    }
    
    
    //  MARK: - API
    
    func uploadHashtagToServer(withPostId postId: String ){
        
        guard let caption = captionTextView.text else {return}
        
        let words : [String] = caption.components(separatedBy: .whitespacesAndNewlines)
        
        for var word in words {
            
            if word.hasPrefix("#") {
                
                word = word.trimmingCharacters(in: .punctuationCharacters)
                word = word.trimmingCharacters(in: .symbols)
                
                let hashTagValues = [postId : 1]
                
                HASHTAG_POST_REF.child(word.lowercased()).updateChildValues(hashTagValues)
            }
        }
    }
}
