//
//  MessagesController.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 3/22/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit
import Firebase
private let reuseIdentifier = "MessagesCell"

class MessagesController : UITableViewController {
    
    //  MARK: - Properties
    
    var messages = [Message]()
    
    
    
    //  MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        
        //register cell
        tableView.register(MessagesCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        
    }
    
    //  MARK: UItableView Delegates
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MessagesCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did selct row")
    }
    
    //  MARK: - Handlers
    
    @objc func handleNewMessage(){
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navigationController = UINavigationController(rootViewController: newMessageController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func showChatController(forUser User: User){
        
        let chatController = ChatController(collectionViewLayout : UICollectionViewFlowLayout())
        chatController.user = User
        navigationController?.pushViewController(chatController, animated: true)
        
    }
    
    func configureNavigationBar() {
        navigationItem.title = "Messages"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewMessage))
        
    }
    
 
}
