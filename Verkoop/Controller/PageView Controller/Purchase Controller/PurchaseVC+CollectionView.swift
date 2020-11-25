//
//  BuyCoinsVC+CollectionView.swift
//  Verkoop
//
//  Created by Vijay on 29/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension PurchaseCoinsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return planData?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.BuyPackageCell, for: indexPath) as? BuyPackageCell else {
            return UICollectionViewCell()
        }
        cell.planDetail = planData?.data![indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alertVC = UIAlertController(title: "Purchase Coin", message: "Want to purchase  \(String.getString(planData?.data![indexPath.row].coin)) coins?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Apple Pay", style: .default) { (action) in
            self.purchaseCoinRequest(planDetail: (self.planData?.data![indexPath.row])!)
        }
        
        let cancelAction = UIAlertAction(title: Titles.cancel, style: .cancel, handler: nil)
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        alertVC.view.tintColor = .darkGray
        DispatchQueue.main.async {
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}

extension PurchaseCoinsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 10) / 3, height: (collectionView.frame.width - 10) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


