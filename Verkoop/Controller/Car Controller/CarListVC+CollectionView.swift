//
//  CarListVC+TableView.swift
//  Verkoop
//
//  Created by Vijay on 18/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension CarListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 2 {
            return carData?.data?.items?.count ?? 0
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0://Brands Cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.BrandsCollectionCell, for: indexPath) as? BrandsCollectionCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .white
            cell.topLineView.backgroundColor = .white
            cell.bottomLineView.backgroundColor = .white
            cell.backView.backgroundColor = .white
            cell.viewAllButton.isHidden = false
            cell.delegate = self
            cell.bottomConstraint.update(offset: 0)
            cell.setupCollectionView()
            cell.brandLabel.text = "Brands"
            cell.brandLabel.textColor = kAppDefaultColor
            cell.type = .brandType
            cell.brands = carData?.data?.brands
            cell.collectionView.register(CarBrandsCell.self, forCellWithReuseIdentifier: ReuseIdentifier.CarBrandsCell)
            cell.viewAllButton.addTarget(self, action: #selector(viewAllButtonAction), for: .touchUpInside)
            cell.collectionView.reloadData()
            return cell
        case 1://Budget Cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.BudgetCell, for: indexPath) as? BudgetCell else {
                return UICollectionViewCell()
            }
            cell.lowBudgetButton.tag = 1
            cell.mediumBudgetButton.tag = 2
            cell.highBudgetButton.tag = 3
            cell.fullBudgetButton.tag = 4
            
            cell.lowBudgetButton.addTarget(self, action: #selector(budgetButtonAction(_:)), for: .touchUpInside)
            cell.mediumBudgetButton.addTarget(self, action: #selector(budgetButtonAction(_:)), for: .touchUpInside)
            cell.highBudgetButton.addTarget(self, action: #selector(budgetButtonAction(_:)), for: .touchUpInside)
            cell.fullBudgetButton.addTarget(self, action: #selector(budgetButtonAction(_:)), for: .touchUpInside)
            
            return cell
        case 2://Car List
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.filterDetailCollectionCell, for: indexPath) as? FilterDetailCollectionCell else {
                return UICollectionViewCell()
            }
            let items = carData?.data?.items?[indexPath.row]

            cell.conditionHeightConstraint.constant = 0
            cell.labelItemType.isHidden = false
            
            if let itemType = items?.item_type {
                if itemType == 1 {
                    cell.labelItemType.text = "Condition: New"
                } else {
                    cell.labelItemType.text = "Condition: Used"
                }
            }

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
            cell.likeDislikeButton.tag = indexPath.item
            cell.userProfielButton.tag = indexPath.item
            cell.labelLikes.tag = indexPath.item
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeGesture(_:)))
            cell.labelLikes.addGestureRecognizer(tapGesture)
            cell.userProfielButton.removeTarget(self, action: #selector(userProfileButtonAction(_:)), for: .touchUpInside)
            cell.userProfielButton.addTarget(self, action: #selector(userProfileButtonAction(_:)), for: .touchUpInside)
            cell.likeDislikeButton.removeTarget(self, action: #selector(likeDislikeButtonAction(_:)), for: .touchUpInside)
            cell.likeDislikeButton.addTarget(self, action: #selector(likeDislikeButtonAction(_:)), for: .touchUpInside)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProductDetailVC.instantiate(fromAppStoryboard: .categories)
        let items = carData?.data?.items?[indexPath.row]
        vc.isItemSold = Int.getInt(items?.is_sold) != 0
        vc.itemId = String.getString(items?.id)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func budgetButtonAction(_ sender: UIButton) {
        let favouriteVC = FavouritesCategoriesVC()
        favouriteVC.itemType = .car
        favouriteVC.filterDict = ["brand_id": "", "car_type_id": "", "zone_id": "", "type": "1", "price_no": String.getString(sender.tag)]
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(favouriteVC, animated: true)
        }
    }
    
    //MARK:- IBActions
    //MARK:-
    
    @objc func viewAllButtonAction(_ sender: UIButton) {
        let brandVC = ShowAllBrandsVC()
        brandVC.brands = carData?.data?.brands
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(brandVC, animated: true)
        }
    }
    
    @objc func likeDislikeButtonAction(_ sender: UIButton) {
        let indexPath = IndexPath(item: sender.tag, section: 0)
        if let item = carData?.data?.items![indexPath.row] {
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
        if let item = carData?.data?.items![sender.tag] {
            let profileVC = OtherUserProfileVC()
            profileVC.userId = String.getString(item.user_id)
            profileVC.userName = item.username ?? "Profile"
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}

extension CarListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: kScreenWidth, height: Constants().getBrandSize())
        case 1:
            return CGSize(width: kScreenWidth, height: Constants().getBudgetFilterSize())
        case 2:
            return CGSize(width: collectionView.frame.width/2, height:Constants().getItemSize() - 30)
        default:
            return CGSize.zero
        }
    }
}
