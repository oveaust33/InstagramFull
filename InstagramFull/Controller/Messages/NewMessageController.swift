//
//  NewMessageController.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 3/22/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "NewMessageCell"

class NewMessageController : UITableViewController {
    //  MARK: - Properties
    
    var users = [User]()
    
    
    
    //  MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        fetchUsers()
        
        //register cell
        tableView.register(NewMessageCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        
    }
    
    //  MARK: UItableView Delegates
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NewMessageCell
        
        cell.user = users[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did selct row")
}
    
    //  MARK: - Handlers
    
    @objc func handleCancel(){
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func configureNavigationBar() {
        
        navigationItem.title = "New Message"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title:"Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    //  MARK: - API
    
    func fetchUsers(){
        
        USER_REF.observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            
            if uid != Auth.auth().currentUser?.uid {
                
                Database.fetchUser(with: uid, completion: { (user) in
                    self.users.append(user)
                    self.tableView.reloadData()
                })
            }
            
        }
    }
 
    
}
