//
//  EditProfileController.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 4/4/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit
import Firebase

class EditProfileController : UIViewController {
    
    //  MARK: - Properties
    
    var user : User?
    var imageChanged = false
    var userNameChanged = false
    var userProfileController: UserProfileVC?
    var updatedUserName : String?
    
    let profileImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        
        return iv
    }()
    
    let changePhotoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Profile Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleChangeProfilePhoto), for: .touchUpInside)
        
        return button
    }()
    
    let separatorView : UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    let userNameTextField : UITextField = {
        let tf = UITextField()
        tf.textAlignment = .left
        tf.borderStyle = .none
        return tf
        
    }()
    
    let fullNameTextField : UITextField = {
        let tf = UITextField()
        tf.textAlignment = .left
        tf.borderStyle = .none
        tf.isUserInteractionEnabled = false
        return tf
        
    }()
    
    let fullNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Full Name"
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    let userNameLabel : UILabel = {
        let label = UILabel()
        label.text = "User Name"
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    let fullNameSeparatorView : UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    let userNameSeparatorView : UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    
    //  MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        userNameTextField.delegate = self
        
        configureNavigationBar()
        configureViewComponents()
        loadUserData()
    }
    
    //  MARK: - Handlers
    
    func configureNavigationBar(){
        
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleDone))
    }
    
    @objc func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDone(){
        view.endEditing(true)
        
        if userNameChanged{
            self.updateUserName()
        }
        
        if imageChanged{
            self.updateProfileImage()
        }
    }
    
    @objc func handleChangeProfilePhoto(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func loadUserData(){
        
        guard let user = self.user else {return}
        profileImageView.loadImage(with: user.profileImageURL)
        fullNameTextField.text = user.name
        userNameTextField.text = user.userName
    }
    
    func configureViewComponents(){
        
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 150)
        let containerView = UIView(frame: frame)
        containerView.backgroundColor = UIColor.groupTableViewBackground
        view.addSubview(containerView)
        
        containerView.addSubview(separatorView)
        separatorView.anchor(top: nil, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        containerView.addSubview(profileImageView)
        profileImageView.anchor(top: containerView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80/2
        profileImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        containerView.addSubview(changePhotoButton)
        changePhotoButton.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        changePhotoButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        view.addSubview(fullNameLabel)
        fullNameLabel.anchor(top: containerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(userNameLabel)
        userNameLabel.anchor(top: fullNameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(fullNameTextField)
        fullNameTextField.anchor(top: containerView.bottomAnchor, left: fullNameLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: (view.frame.width / 1.6), height: 0)
        
        view.addSubview(userNameTextField)
        userNameTextField.anchor(top: fullNameTextField.bottomAnchor, left: userNameLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: (view.frame.width / 1.6), height: 0)
        
        view.addSubview(fullNameSeparatorView)
        fullNameSeparatorView.anchor(top: nil, left: fullNameTextField.leftAnchor, bottom: fullNameTextField.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -8, paddingRight: 12, width: 0, height: 0.5)
        
        view.addSubview(userNameSeparatorView)
        userNameSeparatorView.anchor(top: nil, left: userNameTextField.leftAnchor, bottom: userNameTextField.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -8, paddingRight: 12, width: 0, height: 0.5)
    
    }
    
    //  MARK: - API
    
    func updateProfileImage() {
        
        guard imageChanged == true else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let user = self.user else { return }
        guard let profileImageURL = user.profileImageURL else {return}
        
        Storage.storage().reference(forURL: profileImageURL).delete(completion: nil)
        
        let filename = NSUUID().uuidString
        
        guard let updatedProfileImage = profileImageView.image else { return }
        
        guard let uploadData = updatedProfileImage.jpegData(compressionQuality: 0.3) else { return }
        
        STORAGE_PROFILE_IMAGES_REF.child(filename).putData(uploadData, metadata: nil) { (metadata, error) in
            
            if let error = error {
                print("Failed to upload image to storage with error: ", error.localizedDescription)
            }
            
            Storage.storage().reference().child("profile_images").child(filename).downloadURL(completion: { (url, error) in
                
                print("\(url?.absoluteString ?? "Amnei")")
                
                guard let updatedProfileImageURL = url?.absoluteString else {
                    print("Debug : Profile Image URL is nil : ",error?.localizedDescription as Any)
                    return
                }
                USER_REF.child(currentUid).child("profileImageURL").setValue(updatedProfileImageURL, withCompletionBlock: { (err, ref) in
 
                    guard let userProfileController = self.userProfileController else { return }
                    userProfileController.fetchUserCurrentData()
                    self.dismiss(animated: true, completion: nil)
                })
            })
        }
    }
    
    func updateUserName(){
        guard let updatedUserName = self.updatedUserName else {return}
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        guard userNameChanged == true else {return}
        
        USER_REF.child(currentUid).child("userName").setValue(updatedUserName) { (err, ref) in
            
            guard let userProfileController = self.userProfileController else { return }
            userProfileController.fetchUserCurrentData()
            self.dismiss(animated: true, completion: nil)
        }
    }
}



extension EditProfileController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info [UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.image = selectedImage
            self.imageChanged = true
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension EditProfileController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let user = self.user else {return}
        let trimmedString = userNameTextField.text?.replacingOccurrences(of: "\\s+$", with: "",options: .regularExpression)
        
        guard user.userName != trimmedString else {
            
            print("u didn't cahange username")
            userNameChanged = false
            return
        }
        
        guard trimmedString != "" else {
            
            print("Error : please enter a valid username")
            userNameChanged = false
            return
        }
        
        self.updatedUserName = trimmedString?.lowercased()
        userNameChanged = true
    }
}
