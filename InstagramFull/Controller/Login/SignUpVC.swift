//
//  SignUpVC.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/13/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    var imageSelected = false
    
    let plusPhotoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage( UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return button
        
    }()
    
    let emailTextFIeld : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let fullNameTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "full name"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)

        return tf
    }()
    
    let userNameTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "user name"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)

        return tf
    }()
    
    let signUpButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1.0)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(HandleSignup), for: .touchUpInside)
        
        return button
        
    }()
    
    let alreadyHaveAnAccountButton : UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14) , NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign in", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14) , NSAttributedString.Key.foregroundColor : UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1.0)]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(HandleSignIn), for: .touchUpInside)
        
        return button
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //background Color
        view.backgroundColor = UIColor.white
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        configureView()
        view.addSubview(alreadyHaveAnAccountButton)
        alreadyHaveAnAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //selected image
        guard let profileImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            imageSelected = false
            return
        }
        
        //imageSelected true
        
        imageSelected = true
        
        //configure plus photo button with selected image
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 2
        plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @objc func handleSelectPhoto(){
        //configure image picker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        //present image picker
        
        self.present(imagePicker, animated: true , completion: nil)
        
        
    }
    
    @objc func formValidation(){
        
        guard emailTextFIeld.hasText,
              passwordTextField.hasText,
              fullNameTextField.hasText,
              userNameTextField.hasText,
              imageSelected == true else {
                
                signUpButton.isEnabled = false
                signUpButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
                return
                
        }
        
        signUpButton.isEnabled = true
        signUpButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        
    }
    
    @objc func HandleSignup(){
        
        guard let email = emailTextFIeld.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let fullName = fullNameTextField.text else {return}
        guard let userName = userNameTextField.text?.lowercased() else {return}
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("failed to create user with error", error.localizedDescription)
                return
            }
            
            //success
            print("succesfully created user with Firebase")
            
            //set our profile image
            guard let profileImage = self.plusPhotoButton.imageView?.image else {return}
            
            //upload Data
            guard let uploadData = profileImage.jpegData(compressionQuality: 0.3) else {return}
            
            //place Image in Firebase Storage
            let fileName = NSUUID().uuidString
            
            //in order to get Download URLmust add filename to storage REF
            let storageRef = Storage.storage().reference().child("profile_images").child(fileName)
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                //handle error
                if let error = error {
                    print("Failed to upload image to firebase with error", error.localizedDescription)
                    return
                }
                
                //success
                storageRef.downloadURL(completion: { (downloadURL, error) in
                    guard let profileImageURL = downloadURL?.absoluteString else {
                        print("Debug : Profile Image URL is nil")
                        return
                    }
                    
                    //user ID
                    guard let uid = authResult?.user.uid else { return }

                    let dictionaryValues = ["name" : fullName,
                                            "userName" : userName,
                                            "profileImageURL" : profileImageURL]
                    let values = [uid: dictionaryValues]

                    
                    //save User INFO to database
                    Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, ref) in
                        print("Succesfully created user and saved information to Database")
                        guard let mainTabVC = UIApplication.shared.keyWindow?.rootViewController as? MainTabVC else {return}
                        mainTabVC.configureViewController()
                        self.dismiss(animated: true, completion: nil)
                        
                    })
                    
                })
            })
        }
    }
    
    @objc func HandleSignIn(){
        
        _ = navigationController?.popViewController(animated: true)
    
    }
    
    func configureView() {
        let stackview = UIStackView(arrangedSubviews: [emailTextFIeld , passwordTextField , fullNameTextField , userNameTextField , signUpButton])
        stackview.axis = .vertical
        stackview.distribution = .fillEqually
        stackview.spacing = 10
        view.addSubview(stackview)
        stackview.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 240)
    }
    

   

}
