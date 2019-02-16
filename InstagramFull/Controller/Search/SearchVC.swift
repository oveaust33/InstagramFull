//
//  SearchVC.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/14/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit
import Firebase

class SearchVC: UITableViewController {
    
    // Mark : Properties
    
    var users = [User]()
    
    private let reuseIdentifier = "searchUserCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register cell classes
        tableView.register(SearchUserCell.self, forCellReuseIdentifier:  reuseIdentifier)
        configureNavControllers()
        
        //seperator insets
        tableView.separatorInset = UIEdgeInsets (top: 0, left: 64, bottom: 0, right: 0)
        
        fetchUser()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchUserCell
        cell.user = users[indexPath.row]
        
        return cell
    }
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        print("user name is \(user.userName ?? "okokok")")
        
    }
    
    //Handlers
    
    func configureNavControllers() {
        self.navigationItem.title = "Search"
        
    }
    
    
    //MARK : API
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            print(snapshot)
            
            //uid
            let uid = snapshot.key
            
            //get all the users info
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {return}
            
            //user
            let user = User(uid: uid, dictionary: dictionary)
            
            //appending user to variable user
            self.users.append(user)
            
            //reload table view
            
                self.tableView.reloadData()

            
        }
        
    }

    
}
