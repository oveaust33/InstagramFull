//
//  ChatController.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 3/23/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "ChatCell"

class ChatController : UICollectionViewController , UICollectionViewDelegateFlowLayout {
    
    //  MARK: - Properties
    
    lazy var containerView : UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 55)
        
        
        
        containerView.addSubview(sendButton)
        sendButton.anchor(top: nil, left: nil, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 50, height: 0)
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        containerView.addSubview(messageTextField)
        messageTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        containerView.addSubview(separatorView)
        separatorView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        return containerView
        
    }()
    
    let messageTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your texts here..."
        return tf
    }()
    
    let sendButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    var user : User?
    var messages = [Message]()
    
    //  MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(Chatcell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.backgroundColor = .white
        configureNavigationBar()
        observeMessages()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false

    }
    
    override var inputAccessoryView: UIView?{
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    
    
    //  MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Chatcell
        
        return cell
    }
    
    
    //  MARK: - Handlers
    
    @objc func handleSend(){
        
        uploadMessageToServer()
        
        messageTextField.text = nil
    }
    
    @objc func handleInfoTapped(){
        
        print("info handle tapped")
    
    
    }
    
    func configureNavigationBar(){
        
        guard let user = self.user else {return}
        navigationItem.title = user.userName
        
        let infoButton = UIButton(type: .infoLight)
        infoButton.tintColor = .black
        infoButton.addTarget(self, action: #selector(handleInfoTapped), for: .touchUpInside)
        
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        navigationItem.rightBarButtonItem = infoBarButtonItem
    }
    
    //  MARK: - API
    
    func uploadMessageToServer(){
        
        guard let messagText = messageTextField.text else {return}
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        guard let user = self.user else {return}
        let creationDate = NSDate().timeIntervalSince1970
        
        let messageValues = ["creationDate" : creationDate ,
                             "fromId" : currentUid,
                             "toId" : user.uid,
                             "messageText" : messagText] as [String : Any]
        
        let messagesRef = MESSAGES_REF.childByAutoId()
        messagesRef.updateChildValues(messageValues)
        
        guard let messagesRefKey = messagesRef.key else {return}
        USER_MESSAGES_REF.child(currentUid).child(user.uid).updateChildValues([messagesRefKey : 1])
        USER_MESSAGES_REF.child(user.uid).child(currentUid).updateChildValues([messagesRefKey : 1])
        
    }
    
    func observeMessages(){
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        guard let chatPartnerId = self.user?.uid else {return}
        
        USER_MESSAGES_REF.child(currentUid).child(chatPartnerId).observe(.childAdded) { (snapshot) in
            
            let messageId = snapshot.key
            self.fetchMessage(withMessageId: messageId)
        }
    }
    
    func fetchMessage(withMessageId messageId: String){
        MESSAGES_REF.child(messageId).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionary = snapshot.value as? Dictionary<String,AnyObject> else {return}
            let message = Message(dictionary: dictionary)
            self.messages.append(message)
            self.collectionView.reloadData()
        }
    }

}
