//
//  MainTabVC.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/14/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit
import Firebase

class MainTabVC: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - Properties
    
    let dot = UIView()
    var notificationIDs = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate
        self.delegate = self
        configureViewController()
        
        //notification Dot
        configureNotificationDot()
        
        //observe notofocation
        observeNotification()
        
        //user login checking
        checkIfUserILoggedIn()
        
        

    }
    
    //  MARK: - Handlers
  
    
    //function to create View Controller that exists within TabBarVC
    func configureViewController(){
        
        //home View Controller
        let feedVC = constructNavController(unselectedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootViewCOntroller: FeedVC(collectionViewLayout : UICollectionViewFlowLayout()))
        
        //Search View Controller
        let searchVC = constructNavController(unselectedImage: UIImage(named: "search_unselected")!, selectedImage: UIImage(named: "search_selected")!, rootViewCOntroller: SearchVC())
        
        
       //Select Image Controller
        let SelectImageVC = constructNavController(unselectedImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "plus_unselected")!)
        
       
        //Notification Controller
        let notificationVC = constructNavController(unselectedImage: UIImage(named: "like_unselected")!, selectedImage: UIImage(named: "like_selected")!, rootViewCOntroller: NotificationVC())
        
        //Profile View Controller
        let userProfileVC = constructNavController(unselectedImage: UIImage(named: "profile_unselected")!, selectedImage: UIImage(named: "profile_selected")!, rootViewCOntroller: UserProfileVC(collectionViewLayout : UICollectionViewFlowLayout()))
        
        //View COntrollers to be added to tab controller
        viewControllers = [feedVC ,searchVC , SelectImageVC, notificationVC , userProfileVC ]
        
        //tab bar tint color
        tabBar.tintColor = .black
        
    }
    
    
    
    // function to construct navigation Controller
    func constructNavController(unselectedImage : UIImage , selectedImage : UIImage , rootViewCOntroller : UIViewController = UIViewController()) -> UINavigationController{
        //construct nav Controller
        let navController = UINavigationController(rootViewController: rootViewCOntroller)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.tintColor = .black
        
        return navController
        
    }
    
    func configureNotificationDot(){
        
        if UIDevice().userInterfaceIdiom == .phone {
            
            let tabBarHeight = tabBar.frame.height
            
            if UIScreen.main.nativeBounds.height == 2436{
                // Configure for iPhone X
                dot.frame = CGRect(x: view.frame.width/5 * 3, y: view.frame.height - tabBarHeight , width: 6, height: 6)
            }
            
            else {
                //Configure for other Iphones
                dot.frame = CGRect(x: view.frame.width/5 * 3, y: view.frame.height - 16 , width: 6, height: 6)
            }
            
            //create Dot
            dot.center.x = (view.frame.width / 5 * 3 + (view.frame.width / 5) / 2)
            dot.backgroundColor = UIColor(red: 233/255, green: 30/255, blue: 99/255, alpha: 1)
            dot.layer.cornerRadius = dot.frame.width / 2
            self.view.addSubview(dot)
            dot.isHidden = true
        }
    }
    
    //  MARK: - TabBar Controller
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of : viewController)
        
        if index == 2 {
            let selectImageVC = SelectImageVC(collectionViewLayout : UICollectionViewFlowLayout())
            let navController = UINavigationController(rootViewController: selectImageVC)
            navController.navigationBar.tintColor = .black 
            
            present(navController, animated: true, completion: nil)
            
            return false
        }
        
        else if index == 3 {
            
            dot.isHidden = true
        }
        
        return true
    }
    
    
    //   MARK: - API

    //Check If user is logged in or not
    func checkIfUserILoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let navController = UINavigationController(rootViewController: LoginVC())
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
    }
    
    func observeNotification(){
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        self.notificationIDs.removeAll()
        
        NOTIFICATIONS_REF.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else {return}
            
            allObjects.forEach({ (snapshot) in
                
                let notificationId = snapshot.key
                
                NOTIFICATIONS_REF.child(currentUid).child(notificationId).child("checked").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    guard let checked = snapshot.value as? Int else {return}
                    
                    if checked == 0 {
                        self.dot.isHidden = false
                        
                    } else {
                        self.dot.isHidden = true
                    }
                })
            })
        }
    }
}
