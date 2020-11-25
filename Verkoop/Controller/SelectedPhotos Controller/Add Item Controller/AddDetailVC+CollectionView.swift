
//
//  AddDetailVC+CollectionView.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 05/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
import UIKit
import Photos

extension AddDetailVC: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photoAsset.count < 10 {
            return photoAsset.count + 1
        } else {
            return photoAsset.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if photoAsset.count < 10 && indexPath.item == photoAsset.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.collectionCellSelectedPhotos, for: indexPath) as! CollectionCellSelectedPhotos
            cell.addimageView.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
                make.height.equalTo(40)
                make.width.equalTo(40)

            }

            cell.imageSelectedPhoto.image = nil
            cell.viewCount.isHidden = true
            cell.addimageView.isHidden = false
            cell.imageSelectedPhoto.backgroundColor = UIColor(hexString: "#ECECEC")
            cell.addimageView.image = UIImage(named: "add_new")
            cell.layoutIfNeeded()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.collectionCellAddItem, for: indexPath) as! CollectionCellAddItem
            cell.imageView.image = nil
            cell.imageView.addShadow(offset: CGSize(width: 5, height: 5), color: .gray, radius: 5, opacity: 0.5)
            cell.imageView.clipsToBounds = true
            let asset = photoAsset[indexPath.row]
            
            if let imageUrl = asset.imageUrl , let url = URL(string: API.assetsUrl + imageUrl) {
                cell.imageView.kf.setImage(with: url)
            } else {
                let manager = PHImageManager.default()
                manager.requestImage(for: asset.assest!, targetSize: CGSize(width: (collectionView.frame.width - 16)/3, height: (collectionView.frame.width - 16)/3), contentMode: .aspectFill, options: nil) { (result, _) in
                    cell.imageView?.image = result
                }
            }
            cell.deleteImageButton.tag = indexPath.item
            cell.deleteImageButton.addTarget(self, action: #selector(deleteImageButtonAction(_:)), for: .touchUpInside)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if photoAsset.count < 10 && indexPath.item == photoAsset.count {
            let selectPhotoVC = SelectedPhotosVC.instantiate(fromAppStoryboard: .categories)
            selectPhotoVC.delegate = self
            if photoAsset.count > 0 {
                let tempAsset = photoAsset.filter { (photo) -> Bool in
                    return photo.imageUrl == nil
                }
                if tempAsset.count > 0 {
                    for asset in tempAsset {
                        selectPhotoVC.photoIndices.append(asset.indexPath)
                    }
                }
                selectPhotoVC.alreadySelectedImageCount = photoAsset.count - tempAsset.count
            }
            selectPhotoVC.isEdit = true
            present(selectPhotoVC, animated: true, completion: nil)
        }
    }
    
    @objc func deleteImageButtonAction(_ sender: UIButton) {
        if isEdit {
            let asset = self.photoAsset[sender.tag]
            if asset.imageId != nil {
                removedImage.append(Int.getInt(asset.imageId))
            }
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: 0, section: 0)
                if let cell = self.tableView.cellForRow(at: indexPath) as? TableCellSelectedPhotos {
                    self.photoAsset.remove(at: sender.tag)
                    cell.collectionSelectedPhoto.reloadData()
                    self.addDetailDict[AddDetailDictKeys.image.rawValue] = self.photoAsset
//                    self.enableAppyButton()
                }
            }
        } else {
            if let delegateObject = delegate {
                delay(time: 0.1) {
                    DispatchQueue.main.async {
                        delegateObject.didDeselectPhoto!(indexPath: self.photoAsset[sender.tag].indexPath)
                        self.photoAsset.remove(at: sender.tag)
                        let indexPath = IndexPath(row: 0, section: 0)
                        if let cell = self.tableView.cellForRow(at: indexPath) as? TableCellSelectedPhotos {
                            cell.collectionSelectedPhoto.reloadData()
                        }
                        self.addDetailDict[AddDetailDictKeys.image.rawValue] = self.photoAsset
//                        self.enableAppyButton()
                    }
                }
            }
        }
    }
}

extension AddDetailVC : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 16)/3, height: (collectionView.frame.width - 16)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
}
