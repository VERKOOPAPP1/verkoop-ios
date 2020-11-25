//
//  TableCellProductDetail.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 06/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class TableCellProductDetail: UITableViewCell {

    
    @IBOutlet weak var collectionViewProductImage: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewProductImage.register(UINib(nibName: ReuseIdentifier.collectionCellProductDetail.self, bundle: nil), forCellWithReuseIdentifier: "CollectionCellProductDetail")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
