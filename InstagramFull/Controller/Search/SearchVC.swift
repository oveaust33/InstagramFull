//
//  SearchVC.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/14/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit
import Firebase

class SearchVC: UITableViewController,UISearchBarDelegate , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout , UICollectionViewDataSource {
    
    // Mark : Properties
    
    var users = [User]()
    var filteredUsers = [User]()
    var searchBar = UISearchBar()
    var inSearchMode = false
    var collectionView : UICollectionView!
    var collectionViewEnabled = true
    var posts = [Post]()
    var currentKey : String?
    var userCurrentKey : String?
    
    
    private let reuseIdentifier = "searchUserCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register cell classes
        tableView.register(SearchUserCell.self, forCellReuseIdentifier:  reuseIdentifier)
        
        //Configure SearchBar
        configureSearchBar()
        
        //congigure Collection View
        configureCollectionView()
        
        //fetchPost
        fetchPost()
        
        //seperator insets
        tableView.separatorInset = UIEdgeInsets (top: 0, left: 64, bottom: 0, right: 0)

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredUsers.count
        } else {
            return users.count
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if users.count>3 {
            
            if indexPath.item == users.count - 1 {
                
                self.fetchUser()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchUserCell
        
        var user : User!
        if inSearchMode {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        
        cell.user = user
        
        return cell
    }
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var user : User!
        
        if inSearchMode {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        
        //create instance of UserProfileVC
        let userProfileVC = UserProfileVC(collectionViewLayout : UICollectionViewFlowLayout())
        
        //Passes User from SearchVC to UserProfileVC
        userProfileVC.user = user
                
        //push View Controllers
        navigationController?.pushViewController(userProfileVC, animated: true)
        
        
    }
    
    //  MARK: - UICollectonView
    
    func configureCollectionView(){
        
        let layOut = UICollectionViewFlowLayout()
        layOut.scrollDirection = .vertical
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - (tabBarController?.tabBar.frame.height)! - (navigationController?.navigationBar.frame.height)!)
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layOut)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        
        tableView.addSubview(collectionView)
        
        collectionView.register(SearchPostCell.self, forCellWithReuseIdentifier: "SearchPostCell")
        tableView.separatorColor = .clear
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2)/3
        return CGSize(width: width, height: width)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if posts.count > 20 {
            if indexPath.item == posts.count - 1{
                self.fetchPost()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchPostCell", for: indexPath) as! SearchPostCell
        cell.post = posts[indexPath.item]
        
        return cell
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedVC = FeedVC(collectionViewLayout : UICollectionViewFlowLayout())
        feedVC.viewSinglePost = true
        
        feedVC.post = posts[indexPath.item]
        
        navigationController?.pushViewController(feedVC, animated: true)
    }
    
    //MARK: - Handlers
 
    func configureSearchBar(){
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.barTintColor = UIColor(red: 240/255, green: 230/255, blue: 240/255, alpha: 1)
        searchBar.tintColor = .black
    }
    
    //  MARK: - UiSearchBar
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        
        fetchUser()
        
        collectionView.isHidden = true
        collectionViewEnabled = false
        
        tableView.separatorColor = .lightGray
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // handle search chage text
        let searchText = searchText.lowercased()
        
        if searchText.isEmpty || searchText == " " {
          
            inSearchMode = false
            tableView.reloadData()
        } else {
            inSearchMode = true
            filteredUsers = users.filter({ (user) -> Bool in
                return user.userName.contains(searchText)
            })
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        searchBar.showsCancelButton = false
        inSearchMode = false
        searchBar.text = nil
        
        collectionViewEnabled = true
        collectionView.isHidden = false
        
        tableView.separatorColor = .clear
        
        tableView.reloadData()
    }
    
    
    
    //MARK: - API
    
    func fetchUser() {
        
        if userCurrentKey == nil {
            
            USER_REF.queryLimited(toLast: 4).observeSingleEvent(of: .value) { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else {return}
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else {return}
                
                allObjects.forEach({ (snapshot) in
                    
                    let uid = snapshot.key
                    Database.fetchUser(with: uid, completion: { (user) in
                        self.users.append(user)
                        self.tableView.reloadData()
                    })
                })
                self.userCurrentKey = first.key
            }
        } else {
            
            USER_REF.queryOrderedByKey().queryEnding(atValue: self.userCurrentKey).queryLimited(toLast: 5).observeSingleEvent(of: .value) { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else {return}
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else {return}
                
                allObjects.forEach({ (snapshot) in
                    
                    let uid = snapshot.key
                    
                    if uid != self.userCurrentKey{
                       
                        Database.fetchUser(with: uid, completion: { (user) in
                            
                            self.users.append(user)
                            self.tableView.reloadData()
                        })
                    }
                })
                
                self.userCurrentKey = first.key
            }
        }
    }
    
    func fetchPost(){
        
        if currentKey == nil {
            
            POSTS_REF.queryLimited(toLast: 21).observeSingleEvent(of: .value) { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else {return}
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else {return}
                
                allObjects.forEach({ (snapshot) in
                    
                    let postId = snapshot.key
                    Database.fetchPost(with: postId, completion: { (post) in
                        self.posts.append(post)
                        self.collectionView.reloadData()
                    })
                })
                self.currentKey = first.key
            }
        } else {
            
            //paginate here
            POSTS_REF.queryOrderedByKey().queryEnding(atValue: self.currentKey).queryLimited(toLast: 10).observeSingleEvent(of: .value) { (snapshot) in
                
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else {return}
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else {return}
                
                allObjects.forEach({ (snapshot) in
                    let postId = snapshot.key
                    if postId != self.self.currentKey {
                        
                        Database.fetchPost(with: postId, completion: { (post) in
                            self.posts.append(post)
                            self.collectionView.reloadData()
                        })
                    }
                })
                self.currentKey = first.key
            }
        }
    }
}
