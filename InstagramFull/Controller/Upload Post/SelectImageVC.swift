//
//  SelectImageVC.swift
//  InstagramFull
//
//  Created by Iftiquar Ahmed  on 2/20/19.
//  Copyright © 2019 Iftiquar Ahmed . All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "SelectPhotoCell"
private let headerIdentifier = "SelectPhotoHeader"


class SelectImageVC : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //  MARK: - Properties
    var images = [UIImage]()
    var assets = [PHAsset]()
    var selectedImage : UIImage?
    var header : SelectPhotoHeader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register cell classes
        collectionView.register(SelectPhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(SelectPhotoHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        collectionView.backgroundColor = .white
        
        //Configure nav buttons
        self.configureNavigationButton()
        
        //Fetch Photos
        self.fetchPhotos()
        
    }
    
    //  MARK: - UICollectionView FlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3)/4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        
        return CGSize(width: width, height: width)
    }
    
    //  MARK: - UiCollectionView Data Source
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! SelectPhotoHeader
        
        self.header = header
        
        if let selectedImage = self.selectedImage {
            
            //index our selected image
            if let index = self.images.index(of: selectedImage){
                
                //asset associated with selected image
                let selectedAsset = self.assets[index]
                
                let imageManager = PHImageManager.default()
                let TargetSize = CGSize(width: 600, height: 600)
                
                //request image
                imageManager.requestImage(for: selectedAsset, targetSize: TargetSize, contentMode: .default, options: nil) { (image, info) in
                    
                    header.photoImageView.image = image
                    
                }
            }
            
        }
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SelectPhotoCell
        cell?.photoImageView.image = images[indexPath.row]

        return cell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = images[indexPath.row]
        self.collectionView.reloadData()
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        
    }
    
    //  MARK : - Handlers
    
    @objc func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNext(){
        print("Handle next Tapped ....")
        let uploadPostVC = UploadPostVC()
        uploadPostVC.selectedImage = self.header?.photoImageView.image //get the real pixel of image,we could use SelectedImage
        navigationController?.pushViewController(uploadPostVC, animated: true)
        
    }
    
    func configureNavigationButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
        
    }
    
    func getAssetFetchOptions() -> PHFetchOptions {
        
        let options = PHFetchOptions()
        
        //Fetch Limit
        options.fetchLimit = 30
        
        //Sort Photos by date
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        
        //set sort descriptor for options
        options.sortDescriptors = [sortDescriptor]
        
        //return options
        return options
    }
    
    
    func fetchPhotos() {
        
        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: getAssetFetchOptions())
        
        print("Running")
        
        //fetch images on background thread
        DispatchQueue.global(qos: .background).async {
            
            //enumerate objects
            allPhotos.enumerateObjects({ (asset, count, stop) in
                
                print("\(count) times")
                
                let imageManger = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                
                //Request Image Representation for specified asset
                
                imageManger.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    if let image = image {
                        
                        //Append image to data source
                        self.images.append(image)
                        
                        //append asset
                        self.assets.append(asset)
                        
                        //set selected image with first image
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                        
                        //reload collection view with images once count has completed
                        if count == allPhotos.count - 1 {
                            
                            //reload collection view on main thread
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                            
                        }

                    }
                })
                
                
            })
        }
  
        
    }
    

}
