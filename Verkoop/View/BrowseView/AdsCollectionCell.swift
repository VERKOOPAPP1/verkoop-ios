//
//  AdsCollectionCell.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 06/12/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import UIKit

class AdsCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionViewAds: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewAds.register(UINib(nibName: ReuseIdentifier.itemsCollectionCell, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifier.itemsCollectionCell)
    }
}
