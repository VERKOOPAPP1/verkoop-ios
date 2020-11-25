//
//  SelectedPhotosVC.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 07/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit
import Photos

class SelectedPhotosVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    var alreadySelectedImageCount = 0
    var isEdit = false
    var isPresent = false
    var photoAsset = [Photos]()
    var count = 0
    var imagePicker = UIImagePickerController()
    var photoIndices : [IndexPath] = []
    var delegate: DidSelectPhotosDelegate?

    let manager = PHImageManager.default()
    
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var collectionViewPhotos: UICollectionView!
    @IBOutlet weak var labelTotalImageCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    func setUpView() {
        collectionViewPhotos.register(UINib(nibName: ReuseIdentifier.collectionCellSelectedPhotos, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifier.collectionCellSelectedPhotos)
        self.imagePicker.delegate = self
        MediaManager.sharedManager.delegate = self
        MediaManager.sharedManager.getPhotoGallery()
    }

    func getImages() {
        let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        assets.enumerateObjects({ (object, count, stop) in
            self.photoAsset.append(Photos(selectedIndex: false, assest: object, count: 0, indexPath: IndexPath(item: count + 1, section: 0), imageUrl: nil, imageId: nil))
        })
        photoAsset.reverse()
        photoAsset.insert(Photos(selectedIndex: false, assest: nil, count: 0, indexPath: IndexPath(item: 0, section: 0), imageUrl: nil, imageId: nil), at: 0)
        //In editing Mode, show the previous selected photos
        if photoIndices.count > 0 && isEdit {
            for (index, indexPath) in photoIndices.enumerated() {
                photoAsset[indexPath.row].selectedIndex = true
                photoAsset[indexPath.row].count = index + 1
            }
            count = photoIndices.count
            setSelected(count: count)
        }
        OperationQueue.main.addOperation {
            self.collectionViewPhotos.reloadData()
        }
    }
    
    func refreshImage() {
        if let assets = (PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)).lastObject {
            photoAsset.insert(Photos(selectedIndex: false, assest: assets, count: 0, indexPath: IndexPath(item: 1, section: 0), imageUrl: nil, imageId: nil), at: 1)
            for i in 2..<photoAsset.count {
                let indexPath = photoAsset[i].indexPath
                photoAsset[i].indexPath = IndexPath(item: (indexPath?.item)! + 1, section: 0)
            }
            
            for (i, indexes) in photoIndices.enumerated() {
                var indexPath = indexes
                indexPath.item += 1
                photoIndices[i] = indexPath
            }
        }
        self.collectionViewPhotos.reloadData()
    }
    
    @IBAction func buttonTappedClose(sender: UIButton) {
        if isEdit {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func buttonTappedNext(sender: UIButton) {
        if isEdit {
            if let delegateObject = delegate {
                var photos: [Photos] = []
                for indexPath in photoIndices {
                    photos.append(photoAsset[indexPath.row])
                }
                let selectedPhotos = photoAsset.filter { (photo) -> Bool in
                    return photo.selectedIndex == true
                }
                delegateObject.didPhotosSelected(photos: selectedPhotos)
                delay(time: 0.1) {
                    OperationQueue.main.addOperation {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        } else {
            let vc = AddDetailVC.instantiate(fromAppStoryboard: .categories)
            vc.delegate = self
            for indexPath in photoIndices {
                vc.photoAsset.append(photoAsset[indexPath.row])
            }
            vc.setData(productDetail: ProductDetailModel())
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        guard let selectedImage = info[.originalImage] as? UIImage else {
            imagePicker.dismiss(animated: true, completion: nil)
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            DisplayBanner.show(message: error.localizedDescription)
        } else {
            DispatchQueue.main.async {
                self.refreshImage()
            }
        }
    }
}

