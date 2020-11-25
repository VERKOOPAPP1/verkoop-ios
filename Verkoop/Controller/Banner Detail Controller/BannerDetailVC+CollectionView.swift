//
//  BannerDetailVC+CollectionView.swift
//  Verkoop
//
//  Created by Vijay on 10/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Kingfisher

extension BannerDetailVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == HomeScreenCollectionView.advertisment.rawValue {
            if let count = bannerData?.data?.banner?.count {
                return count * dummyCount
            } else {
                return 0
            }
        } else {
            var count = 0
            if let ads = bannerData?.data?.banner, ads.count > 0 {
                count += 1
            }
            return (bannerData?.data?.items?.count ?? 0) + count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == HomeScreenCollectionView.advertisment.rawValue {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.itemsCollectionCell, for: indexPath) as? ItemsCollectionCell else {
                return UICollectionViewCell()
            }
            let itemIndex = indexPath.item % (bannerData?.data?.banner?.count)!
            let advertisement = bannerData?.data?.banner?[itemIndex]
            cell.imageViewItem.image = nil
            if let urlString = advertisement?.image {
                let urlStr = API.assetsUrl + urlString
                let str = urlStr.replacingOccurrences(of: "\\", with: "/")
                if let mergeUrl = URL(string: str) {
                    cell.imageViewItem.kf.setImage(with: mergeUrl, placeholder: nil)
                }
            }
            return cell
        } else {
            if indexPath.row == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.adsCollectionCell, for: indexPath) as? AdsCollectionCell else {
                    return UICollectionViewCell()
                }
                cell.collectionViewAds.tag = 0
                cell.collectionViewAds.delegate = self
                cell.collectionViewAds.dataSource = self
                cell.pageControl.numberOfPages = (bannerData?.data?.banner?.count)!
                customPageControl = cell.pageControl
                advertiseCollectionView = cell.collectionViewAds
                cell.collectionViewAds.reloadData()
                if !timerStarted {
                    timerStarted = true
                    startTimer()
                }
                return cell
            }  else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.filterDetailCollectionCell, for: indexPath) as? FilterDetailCollectionCell else {
                    return UICollectionViewCell()
                }
                let items = bannerData?.data?.items?[indexPath.item - 1]
                
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
                    cell.imageUserProfile.kf.setImage(with: url)
                } else {
                    cell.imageUserProfile.image = UIImage(named: "pic_placeholder")
                }
                cell.likeDislikeButton.isSelected = items?.is_like ?? false
                cell.likeDislikeButton.tag = indexPath.item - 1
                cell.labelLikes.tag = indexPath.item - 1
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeGesture(_:)))
                cell.labelLikes.addGestureRecognizer(tapGesture)
                cell.likeDislikeButton.removeTarget(self, action: #selector(likeDislikeButtonAction(_:)), for: .touchUpInside)
                cell.likeDislikeButton.addTarget(self, action: #selector(likeDislikeButtonAction(_:)), for: .touchUpInside)
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.tag == HomeScreenCollectionView.item.rawValue {
            if indexPath.item == 0 {
                centerIfNeeded(collectionView: collectionView)
                startTimer()
            } else if let count = bannerData?.data?.items?.count, indexPath.item - 2 == count {
                if let totalPage = bannerData?.data?.totalPage , pageIndex < totalPage{
//                    loadMoreData(params: nil)
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
}

extension BannerDetailVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == HomeScreenCollectionView.item.rawValue && indexPath.item > 0 {
            let vc = ProductDetailVC.instantiate(fromAppStoryboard: .categories)
            let items = bannerData?.data?.items?[indexPath.row - 4]
            vc.isItemSold = Int.getInt(items?.is_sold) != 0
            vc.itemId = String.getString(items?.id)
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension BannerDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == HomeScreenCollectionView.advertisment.rawValue {
            return CGSize(width: collectionView.frame.width, height: 200)
        } else {
            if indexPath.row == 0 {
                return CGSize(width: collectionView.frame.width, height: 200)
            } else {
                return CGSize(width: collectionView.frame.width/2, height:Constants().getItemSize() - 45)
            }
        }
    }
    
    @objc func likeDislikeButtonAction(_ sender: UIButton) {
        let indexPath = IndexPath(item: sender.tag, section: 0)
        if let item = bannerData?.data?.items![indexPath.row - 1] {
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
}
