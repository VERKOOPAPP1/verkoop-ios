//
//  BrandsCell+CollectionDelegate.swift
//  Verkoop
//
//  Created by Vijay on 19/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension BrandsCollectionCell : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if type == .brandType {
            return brands?.count ?? 0
        } else if type == .bodyType {
            return carBodies?.count ?? 0
        } else if type == .zoneType {
            return zoneArray.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.CarBrandsCell, for: indexPath) as? CarBrandsCell else {
            return UICollectionViewCell()
        }
        
        if type == .brandType {
            cell.brandNameLabel.backgroundColor = .clear
            cell.backView.backgroundColor = UIColor(hexString: "#EDEDED")
            cell.brandImageView.isHidden = false
            cell.bodyImageView.isHidden = true            
            cell.brandNameLabel.textColor = .black
            let brand = brands?[indexPath.item]
            cell.brandNameLabel.textAlignment = .center
            cell.brandNameLabel.text = brand?.name
            if let url = URL(string: API.assetsUrl + (brand?.image ?? "")) {
                cell.brandImageView.kf.setImage(with: url)
            } else {
                cell.brandImageView.backgroundColor = .clear
            }
        } else if type == .bodyType {
            cell.backView.backgroundColor = UIColor(hexString: "#EDEDED")
            cell.brandImageView.isHidden = true
            cell.bodyImageView.isHidden = false
            cell.brandNameLabel.textColor = .white
            let body = carBodies?[indexPath.item]
            cell.brandNameLabel.textAlignment = .left
            cell.brandNameLabel.text = body?.name
            cell.bodyImageView.addShadow(offset: CGSize(width: 3, height: 3), color: .black, radius: 5, opacity: 0.3)
            if let url = URL(string: API.assetsUrl + (body?.image ?? "")) {
                cell.bodyImageView.kf.setImage(with: url)
            } else {
                cell.bodyImageView.backgroundColor = .clear
            }
            cell.brandLabelView.isHidden = false
            cell.layoutIfNeeded()
//            cell.bodyImageView.setGradientLinearLeftToRight(colors: [UIColor(hexString: "#686868").cgColor], gradientFrame: CGRect(x: 0, y: cell.bodyImageView.frame.height - 30, width: cell.bodyImageView.frame.width, height: 30))
        } else if type == .zoneType {
            cell.brandNameLabel.backgroundColor = .clear
            cell.backView.backgroundColor = UIColor(hexString: "#EDEDED")
            cell.brandImageView.isHidden = true
            cell.bodyImageView.isHidden = false
            cell.brandNameLabel.textColor = .white
            let zone = zoneArray[indexPath.item]
            cell.brandNameLabel.textAlignment = .left
            cell.brandNameLabel.text = zone["name"]
            cell.bodyImageView.addShadow(offset: CGSize(width: 3, height: 3), color: .black, radius: 5, opacity: 0.3)
            if let url = URL(string: zone["image"]! ) {
                cell.bodyImageView.kf.setImage(with: url)
            } else {
                cell.bodyImageView.backgroundColor = .clear
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if type == .brandType {
             let brand = brands?[indexPath.item]
            if let delegateObject = delegate {
                delegateObject.didBrandFilteredSelected?(brand_id: String.getString(brand?.id))
            }
        } else if type == .bodyType {
             let body = carBodies?[indexPath.item]
            if let delegateObject = delegate {
                delegateObject.didCarTypeFilteredSelected?(car_type_id: String.getString(body?.id))
            }
        } else if type == .zoneType {
             let zone = zoneArray[indexPath.item]
            if let delegateObject = delegate {
                delegateObject.didZoneTypeFilteredSelected?(zone_id: zone["id"]!)
            }
        }
    }
}

extension BrandsCollectionCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (type == .brandType) ? collectionView.frame.height + 20 : collectionView.frame.height, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if type == .brandType {
            return 10
        } else if type == .bodyType {
            return 6
        } else if type == .zoneType {
            return 6
        }
        return 0
    }
}


