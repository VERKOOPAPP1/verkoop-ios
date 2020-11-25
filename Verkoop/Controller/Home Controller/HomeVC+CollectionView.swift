//
//  HomeVC+CollectionView.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 06/12/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import Kingfisher

extension HomeVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == HomeScreenCollectionView.advertisment.rawValue {
            if let count = itemData?.data?.advertisments?.count {
              return count * dummyCount
            } else {
                return 0
            }
        } else if collectionView.tag == HomeScreenCollectionView.category.rawValue {
            return itemData?.data?.categories?.count ?? 0
        } else if collectionView.tag == HomeScreenCollectionView.dailyPicks.rawValue {
            return itemData?.data?.daily_pic?.count ?? 0
        } else if collectionView.tag == HomeScreenCollectionView.item.rawValue {
            let count = 4
//            if let ads = itemData?.data?.advertisments, ads.count > 0 {
//                count += 1
//            }
//            if let catg = itemData?.data?.categories, catg.count > 0 {
//                count += 1
//            }
//            if let dailyPicks = itemData?.data?.daily_pic, dailyPicks.count > 0 {
//                count += 1
//            }
            return (itemData?.data?.items?.count ?? 0) + count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == HomeScreenCollectionView.advertisment.rawValue {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.itemsCollectionCell, for: indexPath) as? ItemsCollectionCell else {
                return UICollectionViewCell()
            }
            let itemIndex = indexPath.item % (itemData?.data?.advertisments?.count)!
            let advertisement = itemData?.data?.advertisments?[itemIndex]
            cell.imageViewItem.image = nil
            if let urlString = advertisement?.image {
                let urlStr = API.assetsUrl + urlString
                let str = urlStr.replacingOccurrences(of: "\\", with: "/")
                if let mergeUrl = URL(string: str) {
                    cell.imageViewItem.kf.setImage(with: mergeUrl, placeholder: nil)
                }
            }
            return cell
        } else if collectionView.tag == HomeScreenCollectionView.category.rawValue {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.selectCategoryCollectionCell, for: indexPath) as? SelectCategoryCollectionCell else {
                return UICollectionViewCell()
            }
            
            let categoryData = itemData?.data?.categories?[indexPath.row]
            cell.imageViewCategory.image = nil
            if let urlString = categoryData?.image {
                if let mergeUrl = URL(string: API.assetsUrl + urlString) {
                    cell.imageViewCategory.kf.setImage(with: mergeUrl, placeholder: nil)
                }
            }
            cell.labelCategory.text = categoryData?.name
            cell.imageViewCheck.isHidden = true
            cell.viewOuter.setRadius(7)
            cell.viewInner.isHidden = true
            return cell
            
        } else if collectionView.tag == HomeScreenCollectionView.dailyPicks.rawValue {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.filterDetailCollectionCell, for: indexPath) as? FilterDetailCollectionCell else {
                return UICollectionViewCell()
            }
            pickCollectionView = collectionView
            cell.verticalLineView.isHidden = false
            let item = itemData?.data?.daily_pic?[indexPath.row]
            
            if let value = item?.is_sold, value == 1 {
                cell.soldView.isHidden = false
                cell.soldLabel.isHidden = false
            } else {
                cell.soldView.isHidden = true
                cell.soldLabel.isHidden = true
            }
            
            if let formattedDate = String.getString(item?.created_at?.date).split(separator: ".").first {
                cell.labelTime.text = Utilities.sharedUtilities.getTimeDifference(dateString: String(formattedDate), isFullFormat: true)
            }
            cell.labelItemName.text = item?.name
            cell.labelLikes.text = item?.items_like_count != nil ? String.getString(item?.items_like_count) : "0"
            if let itemType = item?.item_type {
                if itemType == 1 {
                    cell.labelItemType.text = "Condition: New"
                } else {
                    cell.labelItemType.text = "Condition: Used"
                }
            }
            
            if let price = item?.price {
                cell.labelPrice.text = "R " + String.getString(price)
            }
            cell.labelUsername.text = item?.username
            cell.imageItemCategory.image = nil
            cell.imageUserProfile.image = nil
            cell.imageUserProfile.makeRoundCorner(cell.imageUserProfile.frame.height / 2)
            if let url = URL(string: API.assetsUrl + String.getString(item?.image_url)) {
                cell.imageItemCategory.kf.setImage(with: url, placeholder: UIImage(named: "post_placeholder"))
            } else {
                cell.imageItemCategory.image =  UIImage(named: "post_placeholder")
            }
            
            if let url = URL(string: API.assetsUrl + String.getString(item?.profile_pic)) {
                cell.imageUserProfile.kf.setImage(with: url, placeholder:  UIImage(named: "pic_placeholder"))
            } else {
                cell.imageUserProfile.image = UIImage(named: "pic_placeholder")
            }
            cell.likeDislikeButton.isSelected = item?.is_like ?? false
            cell.likeDislikeButton.tag = indexPath.item
            cell.labelLikes.tag = indexPath.item
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeGesture(_:)))
            cell.labelLikes.addGestureRecognizer(tapGesture)
            cell.likeDislikeButton.accessibilityIdentifier = "0"
            cell.userProfielButton.tag = indexPath.item
            cell.userProfielButton.addTarget(self, action: #selector(userProfileButtonAction(_:)), for: .touchUpInside)
            cell.likeDislikeButton.addTarget(self, action: #selector(likeDislikeButtonAction(_:)), for: .touchUpInside)
            cell.layoutIfNeeded()
            return cell

        }  else if collectionView.tag == HomeScreenCollectionView.item.rawValue {
            if indexPath.row == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.adsCollectionCell, for: indexPath) as? AdsCollectionCell else {
                    return UICollectionViewCell()
                }
                cell.collectionViewAds.tag = 0
                cell.collectionViewAds.delegate = self
                cell.collectionViewAds.dataSource = self
                cell.pageControl.numberOfPages = itemData?.data?.advertisments?.count ?? 0
                customPageControl = cell.pageControl
                advertiseCollectionView = cell.collectionViewAds
                cell.collectionViewAds.reloadData()
                if !timerStarted {
                    timerStarted = true
                    startTimer()
                }
                return cell
            } else if indexPath.row == 1 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.categoryCollectionCell, for: indexPath) as? CategoryCollectionCell else {
                    return UICollectionViewCell()
                }
                cell.collectionViewCategory.register(UINib(nibName: ReuseIdentifier.selectCategoryCollectionCell, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifier.selectCategoryCollectionCell)
                
                cell.collectionViewCategory.tag = 1
                cell.collectionViewCategory.delegate = self
                cell.collectionViewCategory.dataSource = self
                cell.buttonViewAll.addTarget(self, action: #selector(buttonTappedViewAll), for: .touchUpInside)
                cell.collectionViewCategory.reloadData()
                return cell
            } else if indexPath.row == 2 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.BrandsCollectionCell, for: indexPath) as? BrandsCollectionCell else {
                    return UICollectionViewCell()
                }
                
                cell.backgroundColor = UIColor(hexString: "#EBEBEB")
                cell.collectionView.register(UINib(nibName: ReuseIdentifier.filterDetailCollectionCell, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifier.filterDetailCollectionCell)
                cell.collectionView.tag = 3
                cell.collectionView.delegate = self
                cell.collectionView.dataSource = self
                cell.brandLabel.text = "Your Daily Picks"
                cell.viewAllButton.addTarget(self, action: #selector(allDailyPicksAction(_:)), for: .touchUpInside)
                cell.collectionView.reloadData()
                cell.clipsToBounds = true
                return cell
            } else if indexPath.row == 3 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.CarAndPropertyCell, for: indexPath) as? CarAndPropertyCell else {
                    return UICollectionViewCell()
                }
                
                let carTapGesture = UITapGestureRecognizer(target: self, action: #selector(carTapAction(_:)))
                let propertyTapGesture = UITapGestureRecognizer(target: self, action: #selector(propertyTapAction(_:)))
                
                cell.propertyImageView.addGestureRecognizer(propertyTapGesture)
                cell.carImageView.addGestureRecognizer(carTapGesture)
                cell.clipsToBounds = true
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.filterDetailCollectionCell, for: indexPath) as? FilterDetailCollectionCell else {
                    return UICollectionViewCell()
                }
                let items = itemData?.data?.items?[indexPath.item - 4]
                
                if indexPath.row % 2 == 0 {
                    cell.verticalLineView.isHidden = false
                } else {
                    cell.verticalLineView.isHidden = true
                }
                
                if let value = items?.is_sold, value == 1 {
                    cell.soldView.isHidden = false
                    cell.soldLabel.isHidden = false
                } else {
                    cell.soldView.isHidden = true
                    cell.soldLabel.isHidden = true
                }
                
                if let formattedDate = String.getString(items?.created_at?.date).split(separator: ".").first {
                    cell.labelTime.text = Utilities.sharedUtilities.getTimeDifference(dateString: String(formattedDate), isFullFormat: true)
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
                    cell.imageItemCategory.kf.setImage(with: url, placeholder: UIImage(named: "post_placeholder"))
                } else {
                    cell.imageItemCategory.image =  UIImage(named: "post_placeholder")
                }
                
                if let url = URL(string: API.assetsUrl + String.getString(items?.profile_pic)) {
                    cell.imageUserProfile.kf.setImage(with: url, placeholder:  UIImage(named: "pic_placeholder"))
                } else {
                    cell.imageUserProfile.image = UIImage(named: "pic_placeholder")
                }
                cell.likeDislikeButton.isSelected = items?.is_like ?? false
                cell.likeDislikeButton.accessibilityIdentifier = "1"
                cell.likeDislikeButton.tag = indexPath.item - 4
                cell.userProfielButton.tag = indexPath.item - 4
                cell.labelLikes.tag = indexPath.item - 4
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeGesture(_:)))
                cell.labelLikes.addGestureRecognizer(tapGesture)
                cell.userProfielButton.addTarget(self, action: #selector(userProfileButtonAction(_:)), for: .touchUpInside)
                cell.likeDislikeButton.addTarget(self, action: #selector(likeDislikeButtonAction(_:)), for: .touchUpInside)
                cell.layoutIfNeeded()
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.tag == HomeScreenCollectionView.item.rawValue {
            if indexPath.item == 0 {
                centerIfNeeded(collectionView: collectionView)
                startTimer()
            } else if let count = itemData?.data?.items?.count, indexPath.item - 1 == count {
                if let totalPage = itemData?.data?.totalPage , pageIndex < totalPage {
                    loadMoreData(params: nil)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.tag == HomeScreenCollectionView.item.rawValue {
            if indexPath.item == 0 {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    @objc func buttonTappedViewAll(_ sender: UIButton) {
        let vc = CategoriesVC.instantiate(fromAppStoryboard: .categories)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func allDailyPicksAction(_ sender: UIButton) {
        let favouriteVC = FavouritesCategoriesVC()
        favouriteVC.delegate = self
        favouriteVC.isDailyPicks = true
        favouriteVC.headerTitleLabel.text = "Your Daily Picks"
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(favouriteVC, animated: true)
        }
    }
}

extension HomeVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == HomeScreenCollectionView.item.rawValue && indexPath.item > 3 {
            let vc = ProductDetailVC.instantiate(fromAppStoryboard: .categories)
            let items = itemData?.data?.items?[indexPath.row - 4]
            vc.isItemSold = Int.getInt(items?.is_sold) != 0
            vc.itemId = String.getString(items?.id)
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        } else if collectionView.tag == HomeScreenCollectionView.category.rawValue {
            let filterVC = CategoriesFilterVC.instantiate(fromAppStoryboard: .categories)
            filterVC.catgoryId = String.getString(itemData?.data?.categories?[indexPath.row].id)
            filterVC.categoryName = itemData?.data?.categories?[indexPath.row].name ?? ""
            navigationController?.pushViewController(filterVC, animated: true)
        } else if collectionView.tag == HomeScreenCollectionView.dailyPicks.rawValue {
            let vc = ProductDetailVC.instantiate(fromAppStoryboard: .categories)
            let items = itemData?.data?.daily_pic?[indexPath.row]
            vc.isItemSold = Int.getInt(items?.is_sold) != 0
            vc.itemId = String.getString(items?.id)
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        } else if collectionView.tag == HomeScreenCollectionView.advertisment.rawValue {
            let detailVC = BannerDetailVC.instantiate(fromAppStoryboard: .advertisement)
            let index = indexPath.item % (itemData?.data?.advertisments?.count)!
            if itemData?.data?.advertisments?[index].category_id != nil {
                detailVC.bannerId = String.getString(itemData?.data?.advertisments?[index].id)
                detailVC.userId = String.getString(itemData?.data?.advertisments?[index].user_id)
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
            }
        }
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == HomeScreenCollectionView.advertisment.rawValue {
            return CGSize(width: collectionView.frame.width, height: 200)
        } else if collectionView.tag == HomeScreenCollectionView.category.rawValue {
            return CGSize(width: collectionView.frame.width * 0.28, height: collectionView.frame.height)
        } else if collectionView.tag == HomeScreenCollectionView.dailyPicks.rawValue {
            return CGSize(width:(collectionView.frame.width - kScreenWidth * 0.09) / 2, height:collectionView.frame.height)
        } else if collectionView.tag == HomeScreenCollectionView.item.rawValue {
            if indexPath.row == 0 {
                return CGSize(width: collectionView.frame.width, height: 200)
            } else if indexPath.row == 1 {
                return CGSize(width: collectionView.frame.width, height: Constants().getCategorySize())
            } else if indexPath.row == 2 {
                return CGSize(width:collectionView.frame.width, height:Constants().getItemSize() + 60)
            } else if indexPath.row == 3 {
                return CGSize(width:collectionView.frame.width, height:Constants().getCarAndPropertySize())
            } else {
                return CGSize(width: collectionView.frame.width/2, height: Constants().getItemSize())
            }
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func likeDislikeButtonAction(_ sender: UIButton) {
        let indexPath = IndexPath(item: sender.tag, section: 0)
        if let identifier = sender.accessibilityIdentifier {
            if identifier == "0" {
                if let item = itemData?.data?.daily_pic?[indexPath.row] {
                    if sender.isSelected {
                        dislikeCategory(params: ["like_id":String.getString(item.like_id)], indexPath: indexPath, identifier: identifier)
                    } else {
                        let param = ["user_id" : String.getString(Constants.sharedUserDefaults.object(forKey: UserDefaultKeys.kUserId)), "item_id": String.getString(item.id)]
                        likeCategory(params: param, indexPath: indexPath, identifier: identifier)
                    }
                }
            } else {
                if let item = itemData?.data?.items?[indexPath.row] {
                    if sender.isSelected {
                        dislikeCategory(params: ["like_id":String.getString(item.like_id)], indexPath: indexPath, identifier: identifier)
                    } else {
                        let param = ["user_id" : String.getString(Constants.sharedUserDefaults.object(forKey: UserDefaultKeys.kUserId)), "item_id": String.getString(item.id)]
                        likeCategory(params: param, indexPath: indexPath, identifier: identifier)
                    }
                }
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
            let profileVC = OtherUserProfileVC()
            profileVC.userId = String.getString(item.user_id)
            profileVC.userName = item.username ?? "Profile"
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    @objc func carTapAction(_ sender: UITapGestureRecognizer) {
        let carListVC = CarListVC()
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(carListVC, animated: true)
        }
    }
    
    @objc func propertyTapAction(_ sender: UITapGestureRecognizer) {
        let propertyListVC = PropertyListVC()
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(propertyListVC, animated: true)
        }
    }
}
