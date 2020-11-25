//
//  FavouritesVC+CollectionView.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 25/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

extension FavouritesCategoriesVC :  UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemData?.data?.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.filterDetailCollectionCell, for: indexPath) as? FilterDetailCollectionCell else {
            return UICollectionViewCell()
        }
        let items = itemData?.data?.items?[indexPath.row]
        
        if indexPath.row % 2 == 0 {
            cell.verticalLineView.isHidden = false
        } else {
            cell.verticalLineView.isHidden = true
        }
        
        if let formattedDate = String.getString(items?.created_at?.date).split(separator: ".").first {
            cell.labelTime.text = Utilities.sharedUtilities.getTimeDifference(dateString: String(formattedDate), isFullFormat: true)
        }
        
        if let value = items?.is_sold, value == 1 {
            cell.soldView.isHidden = false
            cell.soldLabel.isHidden = false
        } else {
            cell.soldView.isHidden = true
            cell.soldLabel.isHidden = true
        }
        
        if itemType == .generic {
            cell.labelItemType.isHidden = false
        } else {
            cell.labelItemType.isHidden = true
        }
        
        cell.labelItemType.isHidden = false
        if let itemType = items?.item_type {
            if itemType == 1 {
                cell.labelItemType.text = "Condition: New"
            } else {
                cell.labelItemType.text = "Condition: Used"
            }
        }
        
        cell.labelItemName.text = items?.name
        cell.labelLikes.text = items?.items_like_count != nil ? String.getString(items?.items_like_count) : "0"
        if let itemType = items?.item_type {
            if itemType == 1 {
                cell.labelItemType.text = "Condition: New"
            } else {
                cell.labelItemType.text = "Condition: Used"
            }
        }
        
        if let price = items?.price {
            cell.labelPrice.text = "R " + String.getString(price)
        }
        cell.labelUsername.text = items?.username
        cell.imageItemCategory.image = nil
        cell.imageUserProfile.image = nil
        cell.imageUserProfile.makeRoundCorner(cell.imageUserProfile.frame.height / 2)
        if let url = URL(string: API.assetsUrl + String.getString(items?.image_url)) {
            cell.imageItemCategory.kf.setImage(with: url)
        } else {
            cell.imageItemCategory.image =  UIImage(named: "post_placeholder")
        }
        
        if let url = URL(string: API.assetsUrl + String.getString(items?.profile_pic)) {
            cell.imageUserProfile.kf.setImage(with: url, placeholder:  UIImage(named: "pic_placeholder"))
        } else {
            cell.imageUserProfile.image = UIImage(named: "pic_placeholder")
        }
        cell.likeDislikeButton.isSelected = items?.is_like ?? false
        cell.likeDislikeButton.tag = indexPath.item
        cell.labelLikes.tag = indexPath.item
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeGesture(_:)))
        cell.labelLikes.addGestureRecognizer(tapGesture)
        cell.likeDislikeButton.addTarget(self, action: #selector(likeDislikeButtonAction(_:)), for: .touchUpInside)
        cell.userProfielButton.tag = indexPath.item
        cell.userProfielButton.removeTarget(self, action: #selector(userProfileButtonAction(_:)), for: .touchUpInside)
        cell.userProfielButton.addTarget(self, action: #selector(userProfileButtonAction(_:)), for: .touchUpInside)
        cell.layoutIfNeeded()
        return cell
    }
}

extension FavouritesCategoriesVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProductDetailVC.instantiate(fromAppStoryboard: .categories)
        let item = itemData?.data?.items?[indexPath.row]
        vc.itemId = String.getString(item?.id)
        vc.delegate = self
        if String.getString(item?.user_id) == Constants.sharedUserDefaults.getUserId() {
            vc.isMyItem = true
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FavouritesCategoriesVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2, height:Constants().getItemSize())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func likeDislikeButtonAction(_ sender: UIButton) {
        let indexPath = IndexPath(item: sender.tag, section: 0)
        if let item = itemData?.data?.items![indexPath.row] {
            if sender.isSelected {
                dislikeCategory(params: ["like_id": String.getString(item.like_id)], indexPath: indexPath)
            } else {
                let param = ["user_id" : String.getString(Constants.sharedUserDefaults.object(forKey: UserDefaultKeys.kUserId)), "item_id": String.getString(item.id)]
                likeCategory(params: param, indexPath: indexPath)
            }
        }
    }
    
    @objc func likeGesture(_ sender: UITapGestureRecognizer) {
        let button = UIButton()
        button.tag = sender.view!.tag
        likeDislikeButtonAction(button)
    }
    
    @objc func userProfileButtonAction(_ sender: UIButton) {
        if let item = itemData?.data?.items![sender.tag] {
            if String.getString(item.user_id) != Constants.sharedUserDefaults.getUserId() {
                let profileVC = OtherUserProfileVC()
                profileVC.userId = String.getString(item.user_id)
                profileVC.userName = item.username ?? "Profile"
                navigationController?.pushViewController(profileVC, animated: true)
            }
        }
    }
}
