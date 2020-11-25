//
//  TableCellSelectedPhotos.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 05/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class TableCellSelectedPhotos: UITableViewCell {

    @IBOutlet weak var collectionSelectedPhoto: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionSelectedPhoto.register(UINib(nibName: ReuseIdentifier.collectionCellAddItem, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifier.collectionCellAddItem)
        collectionSelectedPhoto.register(UINib(nibName: ReuseIdentifier.collectionCellSelectedPhotos, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifier.collectionCellSelectedPhotos)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }        
}
