//
//  SelectedPhotosVC+CollectionView.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 07/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
import UIKit
import Photos


extension SelectedPhotosVC : UICollectionViewDelegate ,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAsset.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let cell = collectionViewPhotos.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.collectionCellSelectedPhotos, for: indexPath)as! CollectionCellSelectedPhotos
            cell.addimageView.isHidden = false
            cell.viewCount.isHidden = true
            cell.imageSelectedPhoto.image = nil
            cell.addimageView.image = UIImage(named: "camera")
            cell.imageSelectedPhoto.backgroundColor = UIColor(hexString: "#ECECEC")
            cell.imageSelectedPhoto.makeBorder(0, color: .clear)
            return cell
        } else {
            let cell = collectionViewPhotos.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.collectionCellSelectedPhotos, for: indexPath)as! CollectionCellSelectedPhotos
            cell.addimageView.isHidden = true
            if isEdit {
                let _ = photoAsset[indexPath.row].indexPath
                photoAsset[indexPath.row].indexPath = indexPath
            } else {
                photoAsset[indexPath.row].indexPath = indexPath
            }
            let asset = photoAsset[indexPath.row]
            if let assetValue = asset.assest {
                manager.requestImage(for: assetValue, targetSize: CGSize(width: (collectionView.frame.width - 16)/3, height: (collectionView.frame.width - 16)/3), contentMode: .aspectFill, options: nil) { (result, _) in
                    cell.imageSelectedPhoto?.image = result
                }
            }
            
            if photoAsset[indexPath.row].selectedIndex == false {
                cell.viewCount.isHidden = true
                cell.imageSelectedPhoto.makeBorder(0, color: .clear)
            } else {
                cell.viewCount.isHidden = false
                cell.imageSelectedPhoto.makeBorder(3, color: kAppDefaultColor)
                cell.labelCount.text = "\(asset.count)"
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                MediaManager.sharedManager.getCamera()
            }
        } else {
            var removeIndex = -1
            if photoAsset[indexPath.row].selectedIndex == true {
                let currentCount = photoAsset[indexPath.row].count
                photoAsset[indexPath.row].count = 0
                for (index,_) in photoAsset.enumerated() {
                    if photoAsset[index].count >= currentCount {
                        photoAsset[index].count = photoAsset[index].count - 1
                    }
                }
                count = count - 1
                removeIndex =  photoIndices.firstIndex(where: {(indexPath1) -> Bool in
                    return indexPath == indexPath1
                }) ?? -1
            } else {
                if count + alreadySelectedImageCount >= 10 {
                    DisplayBanner.show(message: Messages.maximumCount)
                    return
                }
                count = count + 1
                photoIndices.append(indexPath)
            }
            photoAsset[indexPath.row].selectedIndex = !photoAsset[indexPath.row].selectedIndex!
            photoAsset[indexPath.row].count = count
            collectionViewPhotos.reloadItems(at: photoIndices)
            if removeIndex != -1 {
                photoIndices.remove(at: removeIndex)
            }
            setSelected(count: count)
        }
    }
    
    func setSelected(count: Int) {
        buttonNext.isHidden = count == 0
        labelTotalImageCount.text = "\(count) / 10"
    }
    
    func openCamera() {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension SelectedPhotosVC {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 16)/3, height: (collectionView.frame.width - 16)/3)
    }
}
