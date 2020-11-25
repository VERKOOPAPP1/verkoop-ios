//
//  ProductDetailVC+CollectionView.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 06/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
import UIKit

extension ProductDetailVC : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = productDetail?.data?.items_image?.count {
            return count * dummyCount
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.itemsCollectionCell, for: indexPath) as? ItemsCollectionCell else {
            return UICollectionViewCell()
        }
        
        let itemIndex = indexPath.item % (productDetail?.data?.items_image?.count)!
        let images = productDetail?.data?.items_image?[itemIndex]
        if let urlString = images?.url {
            let urlStr = API.assetsUrl + urlString
            let str = urlStr.replacingOccurrences(of: "\\", with: "/")
            if let mergeUrl = URL(string: str) {
                cell.imageViewItem.kf.setImage(with: mergeUrl, placeholder: UIImage(named: "post_placeholder"))
            }
        }
        return cell
    }
}

extension ProductDetailVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScreenWidth , height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
