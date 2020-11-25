//
//  CategoryItemCollectionCell.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 31/01/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class CategoryItemCollectionCell: UICollectionViewCell {

    @IBOutlet weak var labelItemName: UILabel!
    @IBOutlet weak var imageCategoryItem: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    func configureView() {
        imageCategoryItem.setRadius(10)
    }

}
