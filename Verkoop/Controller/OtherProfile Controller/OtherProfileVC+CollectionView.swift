//
//  OtherProfileVC+CollectionView.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 03/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
extension OtherUserProfileVC :  UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = itemData?.data?.items?.count {
            return count
        } else {
            return 0
        }
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
        
        cell.topView.clipsToBounds = true
        cell.heightConstraint.constant = 0.0
        cell.contentView.clipsToBounds = true
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
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIdentifier.OthersProfileHeaderView , for: indexPath) as! OthersProfileHeaderView
            let items = itemData?.data
            headerView.nameLabel.text = items?.username
            let city = "\(String.getString(items?.state)), \(String.getString(items?.city))\n\(String.getString(items?.country))"
            headerView.addressLabel.text = city
            headerView.joiningDataLabel.text = ": " + Utilities.sharedUtilities.getFormattedData(dateString: items?.created_at ?? "")                        
            headerView.goodRatingButton.setTitle(String.getString(items?.good), for: .normal)
            headerView.averageRatingButton.setTitle(String.getString(items?.average), for: .normal)
            headerView.poorRatingButton.setTitle(String.getString(items?.sad), for: .normal)
            headerView.goodRatingButton.addTarget(self, action: #selector(ratingButtonAction(_:)), for: .touchUpInside)
            headerView.poorRatingButton.addTarget(self, action: #selector(ratingButtonAction(_:)), for: .touchUpInside)
            headerView.averageRatingButton.addTarget(self, action: #selector(ratingButtonAction(_:)), for: .touchUpInside)
            
            
            headerView.followerCountLabel.text = String.getString(items?.follower_count)
            headerView.followingCountLabel.text = String.getString(items?.follow_count)
            headerView.followButton.addTarget(self, action: #selector(followButtonAction(_:)), for: .touchUpInside)
            headerView.seeFollowerButton.tag = items?.follower_count ?? 0
            headerView.seeFollowingButton.tag = items?.follow_count ?? 0
            headerView.seeFollowerButton.addTarget(self, action: #selector(seeFollowerButtonAction(_:)), for: .touchUpInside)
            headerView.seeFollowingButton.addTarget(self, action: #selector(seeFollowingButtonAction(_:)), for: .touchUpInside)
            if let url = URL(string: API.assetsUrl + String.getString(itemData?.data?.profile_pic)) {
                headerView.profileImage.kf.setImage(with: url, placeholder: UIImage(named: "pic_placeholder"))
            } else {
                headerView.profileImage.image = UIImage(named: "pic_placeholder")
            }
            headerView.followButton.setRadius(25, .white, 3)
            headerView.followButton.makeRoundCorner(headerView.followButton.frame.height/2)            
            headerView.followButton.isSelected = (String.getString(items?.follower_id).count != 0 && String.getString(items?.follower_id) != "0")
            headerView.followButton.backgroundColor = headerView.followButton.isSelected ? .darkGray : kAppDefaultColor
            headerView.profileImage.makeRoundCorner(30)
            headerView.layoutIfNeeded()
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width : collectionView.frame.size.width, height: 400)
    }
    
    @objc func ratingButtonAction(_ sender: UIButton) {
        let userRatingVC = UserRatingVC.instantiate(fromAppStoryboard: .profile)
        if sender.tag == 1 {
            userRatingVC.ratingType = .good
        } else if sender.tag == 2 {
            userRatingVC.ratingType = .average
        } else {
            userRatingVC.ratingType = .poor
        }
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(userRatingVC, animated: true)
        }
    }
}

extension OtherUserProfileVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProductDetailVC.instantiate(fromAppStoryboard: .categories)
        let items = itemData?.data?.items?[indexPath.row]
        vc.itemId = String.getString(items?.id)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension OtherUserProfileVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2, height:Constants().getItemSize() - 45)
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
                dislikeCategory(params: ["like_id":String.getString(item.like_id)], indexPath: indexPath)
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
    
    @objc func followButtonAction(_ sender: UIButton) {
        guard !isFollowAPIDataLoading else {
            return
        }
        isFollowAPIDataLoading = true
        if sender.isSelected {
            unfollowUser(id: String.getString(itemData?.data?.follower_id))
        } else {
            followUser()
        }
    }
    
    @objc func seeFollowerButtonAction(_ sender: UIButton) {
        if sender.tag > 0 {
            let searchVC = SearchVC()
            searchVC.searchType = .follower
            searchVC.userId = String.getString(itemData?.data?.id)
            OperationQueue.main.addOperation {
                self.navigationController?.pushViewController(searchVC, animated: true)
            }
        } else {
            DisplayBanner.show(message: "No user has followed you")
        }
    }
    
    @objc func seeFollowingButtonAction(_ sender: UIButton) {
        if sender.tag > 0 {
            let searchVC = SearchVC()
            searchVC.searchType = .following
            searchVC.userId = String.getString(itemData?.data?.id)
            OperationQueue.main.addOperation {
                self.navigationController?.pushViewController(searchVC, animated: true)
            }
        } else {
            DisplayBanner.show(message: "You are not following anyone")
        }
    }
}
