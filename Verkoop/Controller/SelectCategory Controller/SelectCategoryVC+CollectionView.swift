//
//  SelectCategoryVC+CollectionView.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 29/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//
import UIKit
import Kingfisher

extension SelectCategoryVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.selectCategoryCollectionCell, for: indexPath) as? SelectCategoryCollectionCell else {return UICollectionViewCell()}
        let category = categoryList?.data?[indexPath.row]
        cell.labelCategory.text = category?.name
        cell.viewOuter.setRadius(7)
        cell.imageViewCategory.image = nil
        let urlString = (category?.image)!
        let url = URL(string: urlString)
        
        cell.imageViewCategory.kf.setImage(with: url, placeholder: nil)
        
        if category?.isSelected ?? false {
            cell.viewInner.setRadius(7, .red, 2)
            cell.viewInner.isHidden = true
            cell.imageViewCheck.isHidden = false
            cell.labelCategory.textColor = .red
        } else {
            cell.viewInner.isHidden = true
            cell.imageViewCheck.isHidden = true
            cell.labelCategory.textColor = .black
        }
        return cell
    }
}

extension SelectCategoryVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height / 3)
    }
}
extension SelectCategoryVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let category = categoryList?.data?[indexPath.row]
        if category?.isSelected ?? false {
            noOfSelectedCategories -= 1
        } else {
            if noOfSelectedCategories == 3 {
                DisplayBanner.show(message: "Maximum categories selected")
                return
            }
            noOfSelectedCategories += 1
        }
        setCategories(selected: noOfSelectedCategories)
        if categoryList?.data?[indexPath.row].isSelected ?? false {
            categoryList?.data?[indexPath.row].isSelected = false
            categoriesIdArray.removeAll { (index) -> Bool in
                return String.getString((categoryList?.data![indexPath.row].id)) == index
            }
        } else {
            categoryList?.data?[indexPath.row].isSelected = true
            categoriesIdArray.append(String.getString(category?.id))
        }
        collectionView.reloadData()
    }
}

