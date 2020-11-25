//
//  OnboardingVC+CollectionView.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 23/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//
import UIKit
extension OnboardingVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.onboardingCollectionCell, for: indexPath) as? OnboardingCollectionCell else {
            return UICollectionViewCell()
            
        }
        cell.imageView.image = model[indexPath.row].image
        return cell
    }    
}

extension OnboardingVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
