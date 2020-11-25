//
//  CategoriesFilterVC+CollectionView.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 31/01/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
import UIKit

extension CategoriesFilterVC : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.tag == 101 {
            if let count = filterData?.data?.subCategoryList?.count ,count > 0 {
                return 2
            } else {
                return 1
            }
        } else if collectionView.tag == 100 {
            return 1
        } else if collectionView.tag == 102 {
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 100 {
            return categoriesFilterArray.count
        } else if collectionView.tag == 101 {
            if let count = filterData?.data?.subCategoryList?.count ,count > 0 , section == 0 {
                return 1
            } else {
                return filterData?.data?.items?.count ?? 0
            }
        } else if collectionView.tag == 102 {
            return filterData?.data?.subCategoryList?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 100 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.filterCollectionCell, for: indexPath) as? FilterCollectionCell else {
                return UICollectionViewCell()
            }
            cell.filterNameLabel.text = categoriesFilterArray[indexPath.row].filterName
            cell.deleteFilterButton.tag = indexPath.row
            cell.deleteFilterButton.removeTarget(self, action: #selector(deleteFilterButtonAction(_:)), for: .touchUpInside)
            cell.deleteFilterButton.addTarget(self, action: #selector(deleteFilterButtonAction(_:)), for: .touchUpInside)
            cell.buttonWidthConstraint.constant = indexPath.row == 0 ? 0 : 30
            cell.layoutIfNeeded()
            return cell
        } else if collectionView.tag == 102 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.FilterCategoryImageCell, for: indexPath) as? FilterCategoryImageCell else {
                return UICollectionViewCell()
            }
            
            let categoryData = filterData?.data?.subCategoryList?[indexPath.row]
            cell.categoryImageView.image = nil
            if let urlString = categoryData?.image {
                if let mergeUrl = URL(string: API.assetsUrl + urlString) {
                    cell.categoryImageView.kf.setImage(with: mergeUrl, placeholder: UIImage(named:"post_placeholder"))
                }
            } else {
                cell.categoryImageView.image = UIImage(named:"post_placeholder")
            }
            cell.categoryImageView.setRadius(6)
            cell.categoryNameLabel.text = categoryData?.name
            return cell
        } else if collectionView.tag == 101 {
            if let count = filterData?.data?.subCategoryList?.count ,count > 0 , indexPath.section == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.AllCategoryHorizontalCell, for: indexPath) as? AllCategoryHorizontalCell else {
                    return UICollectionViewCell()
                }
                cell.collectionView.tag = 102
                cell.collectionView.register(FilterCategoryImageCell.self, forCellWithReuseIdentifier: ReuseIdentifier.FilterCategoryImageCell)
                cell.categoryNameLabel.text = categoryName
                cell.collectionView.delegate = self
                cell.collectionView.dataSource = self
                cell.collectionView.reloadData()
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.filterDetailCollectionCell, for: indexPath) as?  FilterDetailCollectionCell else {
                    return UICollectionViewCell()
                }
                
                let items = filterData?.data?.items![indexPath.row]
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
        } else if collectionView.tag == 102 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.FilterCategoryImageCell, for: indexPath) as? FilterCategoryImageCell else {
                return UICollectionViewCell()
            }
            
            let categoryData = filterData?.data?.subCategoryList?[indexPath.row]
            cell.categoryImageView.image = nil
            if let urlString = categoryData?.image {
                if let mergeUrl = URL(string: API.assetsUrl + urlString) {
                    cell.categoryImageView.kf.setImage(with: mergeUrl, placeholder: UIImage(named:"post_placeholder"))
                }
            } else {
                cell.categoryImageView.image = UIImage(named:"post_placeholder")
            }
            cell.categoryImageView.setRadius(6)
            cell.categoryNameLabel.text = categoryData?.name
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 100 {
            if indexPath.section == 1 {
                let vc = ProductDetailVC.instantiate(fromAppStoryboard: .categories)
                let items = filterData?.data?.items?[indexPath.row]
                vc.itemId = String.getString(items?.id)
                vc.delegate = self
                navigationController?.pushViewController(vc, animated: true)
            }
        } else if collectionView.tag == 101 {
            let vc = ProductDetailVC.instantiate(fromAppStoryboard: .categories)
            let items = filterData?.data?.items?[indexPath.row]
            vc.itemId = String.getString(items?.id)
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        } else if collectionView.tag == 102 {
            let filterVC = CategoriesFilterVC.instantiate(fromAppStoryboard: .categories)
            let subCategory = filterData?.data?.subCategoryList![indexPath.row]
            filterVC.catgoryId = String.getString(subCategory?.id)
            filterVC.categoryName = subCategory?.name ?? ""
            filterVC.type = "1"
            self.navigationController?.pushViewController(filterVC, animated: true)
        }
    }
    
    @objc func likeDislikeButtonAction(_ sender: UIButton) {
        let indexPath = IndexPath(item: sender.tag, section: 0)
        if let item = filterData?.data?.items![indexPath.row] {
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
    
    @objc func userProfileButtonAction(_ sender: UIButton) {
        if let item = filterData?.data?.items![sender.tag] {
            let profileVC = OtherUserProfileVC()
            profileVC.userId = String.getString(item.user_id)
            profileVC.userName = item.username ?? "Profile"
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}

extension CategoriesFilterVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 100 {
            let size = categoriesFilterArray[indexPath.row].filterName.size(withAttributes: [NSAttributedString.Key.font: UIFont.kAppDefaultFontMedium(ofSize: 14.0)])
            return CGSize(width: size.width + 60, height: collectionView.bounds.size.height)
        } else if collectionView.tag == 101 {
            if let count = filterData?.data?.subCategoryList?.count, count > 0 , indexPath.section == 0 {
                return CGSize(width:kScreenWidth, height:kScreenHeight * 0.25)
            } else  {
                return CGSize(width: collectionView.frame.width/2, height:Constants().getItemSize())
            }
        } else if collectionView.tag == 102 {
           return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
        } 
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 100 {
            return 8
        } else  if collectionView.tag == 102 {
            return 0
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    @objc func deleteFilterButtonAction(_ sender: UIButton) {
        let filter = categoriesFilterArray[sender.tag]
        switch filter.filterType {
        case .sort:
            filterParams[FilterKeys.sort_no.rawValue] = "2"
        case .itemType:
            filterParams[FilterKeys.item_type.rawValue] = ""
        case .meetUp:
            filterParams[FilterKeys.meet_up.rawValue] = ""
        case .price:
            filterParams[FilterKeys.max_price.rawValue] = ""
            filterParams[FilterKeys.min_price.rawValue] = ""        
        }
        requestServer(params: filterParams)
    }
}


