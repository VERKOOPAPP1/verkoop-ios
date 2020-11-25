//
//  SelectPackageVC+CollectionView.swift
//  Verkoop
//
//  Created by Vijay on 29/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension SelectPackageVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return advertisementData?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.BuyPackageCell, for: indexPath) as? BuyPackageCell else {
            return UICollectionViewCell()
        }
        cell.buyCoin = false
        cell.planDetail = advertisementData?.data![indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let myCoin = advertisementData?.coins, let investCoin = advertisementData?.data?[indexPath.row].coin, myCoin > investCoin {
            
            if bannerId.count > 0 { // Renew
                let alertVC = UIAlertController(title: "Renew this purchase", message: "Do you want to proceed with this plan?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Proceed", style: .default) { (action) in
                    self.renewBannerRequest(planID: String.getString(self.advertisementData?.data![indexPath.row].id))
                }
                let cancelAction = UIAlertAction(title: Titles.cancel, style: .cancel, handler: nil)
                alertVC.addAction(okAction)
                alertVC.addAction(cancelAction)
                alertVC.view.tintColor = .darkGray
                DispatchQueue.main.async {
                    self.present(alertVC, animated: true, completion: nil)
                }
            } else { // Add New Banner
                let alertVC = UIAlertController(title: "Do you want to proceed with this plan?", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Proceed", style: .default) { (action) in
                    self.submitBannerRequest(planID: String.getString(self.advertisementData?.data![indexPath.row].id))
                }
                let cancelAction = UIAlertAction(title: Titles.cancel, style: .cancel, handler: nil)
                alertVC.addAction(okAction)
                alertVC.addAction(cancelAction)
                alertVC.view.tintColor = .darkGray
                DispatchQueue.main.async {
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
        } else {
            DisplayBanner.show(message: "Please select low package or buy coins")
        }
    }
}

extension SelectPackageVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 10) / 3, height: (collectionView.frame.width - 10) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
