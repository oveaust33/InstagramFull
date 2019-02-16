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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate
        self.delegate = self
        configureViewController()
        
        //user login checking
        checkIfUserILoggedIn()
        
        

    }
    
    //function to create View Controller that exists within TabBarVC
    func configureViewController(){
        
        //home View Controller
        let feedVC = constructNavController(unselectedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootViewCOntroller: FeedVC(collectionViewLayout : UICollectionViewFlowLayout()))
        
        //Search View Controller
        let searchVC = constructNavController(unselectedImage: UIImage(named: "search_unselected")!, selectedImage: UIImage(named: "search_selected")!, rootViewCOntroller: SearchVC())
        
        
        
        //Post COntroller
        let uploadVC = constructNavController(unselectedImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "plus_unselected")!, rootViewCOntroller: PostVC())
        
        //Notification Controller
        let notificationVC = constructNavController(unselectedImage: UIImage(named: "like_unselected")!, selectedImage: UIImage(named: "like_selected")!, rootViewCOntroller: NotificationVC())
        
        //Profile View Controller
        let userProfileVC = constructNavController(unselectedImage: UIImage(named: "profile_unselected")!, selectedImage: UIImage(named: "profile_selected")!, rootViewCOntroller: UserProfileVC(collectionViewLayout : UICollectionViewFlowLayout()))
        
        //View COntrollers to be added to tab controller
        viewControllers = [feedVC ,searchVC , uploadVC, notificationVC , userProfileVC ]
        
        //tab bar tint color
        tabBar.tintColor = .black
        
    }
    
    
    
    
    //function to construct navigation Controller
    func constructNavController(unselectedImage : UIImage , selectedImage : UIImage , rootViewCOntroller : UIViewController = UIViewController()) -> UINavigationController{
        //construct nav Controller
        let navController = UINavigationController(rootViewController: rootViewCOntroller)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.tintColor = .black
        
        return navController
        
    }
    
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


}
