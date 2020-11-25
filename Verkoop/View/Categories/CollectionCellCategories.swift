//
//  CollectionCellCategories.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 08/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class CollectionCellCategories: UICollectionViewCell {
    @IBOutlet weak var labelCategoryName: UILabel!
    @IBOutlet weak var viewCardCategories: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }

    func setUpView() {
        viewCardCategories.makeBorder(2, color: .lightGray)
        viewCardCategories.makeRoundCorner(7)
    }
}
