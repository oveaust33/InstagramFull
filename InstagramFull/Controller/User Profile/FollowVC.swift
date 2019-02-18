//
//  FollowVC.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/19/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit

private let reuseIdentifier = "FollowCell"

class FollowVC : UITableViewController {
    //  MARK: - properties
    
    var viewFollowers = false
    var viewFollowing = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(FollowCell.self, forCellReuseIdentifier: reuseIdentifier)
        navigationItem.title = "Followers"
        
        //configure Nav Controller
        if viewFollowers {
            navigationItem.title = "Followers"
        }
        else {
            navigationItem.title = "Following"
        }
    }
    
    
    
    //  MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier , for: indexPath) as! FollowCell
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    

}

