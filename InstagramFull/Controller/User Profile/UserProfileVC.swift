//
//  UserProfileVC.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/14/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"
private let headerIdentifier = "UserProfileHeader"

class UserProfileVC: UICollectionViewController , UICollectionViewDelegateFlowLayout {
    
    //MARK : Properties
    
    var user : User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //calling the function to set the nav bar title as UserName
        fetchUserCurrentData()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        self.collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        

        
        //change Background color
        self.collectionView.backgroundColor = .white 

    }

    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }
    
    // Profile UI header size and width
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // declare header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath ) as! UserProfileHeader
        
        //set The user in Header
        
        //fetching the user name from firebase database
        let currentUID = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(currentUID!).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary <String , AnyObject> else {return}
            let user = User(uid: currentUID!, dictionary: dictionary)
            self.navigationItem.title = user.userName
            header.user = user
            
        }
        
        return header
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }
    
    //MARK : API
    
    func fetchUserCurrentData(){
        
        
    }
}