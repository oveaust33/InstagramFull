//
//  NotificationVC.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/14/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //clear seperator lines
        tableView.separatorColor = .clear
        
        //register Cell Class
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        //navigation title
        navigationItem.title = "Notification"
        
        
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        
        
        return cell
    }

}
