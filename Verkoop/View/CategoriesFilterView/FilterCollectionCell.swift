//
//  FilterCollectionCell.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 31/01/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class FilterCollectionCell: UICollectionViewCell {

    @IBOutlet weak var buttonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var deleteFilterButton: UIButton!
    @IBOutlet weak var filterNameLabel: UILabel!
    @IBOutlet weak var viewCard: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }

    func setUpView() {
        viewCard.setRadius(4)
    }
}
