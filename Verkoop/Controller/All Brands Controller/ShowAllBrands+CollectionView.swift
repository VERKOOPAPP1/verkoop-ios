//
//  ShowAllBrands+CollectionView.swift
//  Verkoop
//
//  Created by Vijay on 30/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension ShowAllBrandsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brands?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.AllBrandCell, for: indexPath) as? AllBrandCell else {
            return UICollectionViewCell()
        }
        
        let brand = brands?[indexPath.item]
        cell.brandNameLabel.text = brand?.name
        if let url = URL(string: API.assetsUrl + (brand?.image ?? "")) {
            cell.brandImageView.kf.setImage(with: url)
        } else {
            cell.brandImageView.backgroundColor = .clear
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let favouriteVC = FavouritesCategoriesVC()
        favouriteVC.itemType = .car
        let brand = brands?[indexPath.item]
        favouriteVC.filterDict = ["brand_id": String.getString(brand?.id), "car_type_id": "", "zone_id": "", "type": "1", "price_no": ""]
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(favouriteVC, animated: true)
        }
    }
}

extension ShowAllBrandsVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 2) / 3, height: (collectionView.frame.width - 2) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
