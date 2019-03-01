//
//  CommentVC.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 3/1/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "CommentCell"

class CommentVC : UICollectionViewController , UICollectionViewDelegateFlowLayout {
    
    //  MARK: - Properties
    
    var comments = [Comment]()
    var postId : String?
    
    lazy var containerView : UIView = {
        
        let containerView = UIView()
        //containerView.backgroundColor = .red
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        containerView.addSubview(postButton)
        postButton.anchor(top: nil, left: nil, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 50, height: 0)
        postButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        
        containerView.addSubview(commentTextField)
        commentTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: postButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8 , width: 0, height: 0)
        

        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        containerView.addSubview(separatorView)
        separatorView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        containerView.backgroundColor = .white
        
        return containerView
    }()
    
    let commentTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter comment.."
        tf.font = UIFont.systemFont(ofSize: 14)
        
        return tf
        
    }()
    
    let postButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleUploadCommentTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigation title
        navigationItem.title = "Comments"
        
        //Background color
        collectionView.backgroundColor = .white
        
        //  Register Cell Class
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //fetch Comment
        fetchComments()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false

    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    
    
    //  MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommentCell
        cell.comment = comments[indexPath.item]
        return cell
    }
    
    
    //  MARK: - Handlers
    
    @objc func handleUploadCommentTapped(){
        
        guard let postId = self.postId else {return}
        guard let commentText = commentTextField.text else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        let values = ["commentText" : commentText ,
                      "creationDate": creationDate,
                      "uid": uid]   as [String : Any]
        
        COMMENT_REF.child(postId).childByAutoId().updateChildValues(values) { (err, ref) in
            
            self.commentTextField.text = nil // clearing text fields values after posting a comment
            
        }

    }
    
    func fetchComments(){
        
        guard let postId = self.postId else {return}
        COMMENT_REF.child(postId).observe(.childAdded) { (snapshot) in
            
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            
            Database.fetchUser(with: uid, completion: { (user) in
                
                let comment = Comment(user: user, dictionary: dictionary)
                self.comments.append(comment)
                self.collectionView.reloadData()
            
            })
        }
    }
}
