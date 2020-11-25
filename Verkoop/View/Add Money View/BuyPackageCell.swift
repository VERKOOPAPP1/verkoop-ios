//
//  BuyPackageCell.swift
//  Verkoop
//
//  Created by Vijay on 28/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class BuyPackageCell: UICollectionViewCell {

    var buyCoin = true
    var planDetail: TransactionDetail? {
        didSet {
            if buyCoin {
                coinAndTimeLabel.text = String.getString(planDetail?.coin) + " Coins"
                amountAndCoinsLabel.text = "R " + String.getString(planDetail?.amount)
            } else {
                coinAndTimeLabel.text = String.getString(planDetail?.name)
                amountAndCoinsLabel.text = String.getString(planDetail?.coin) + " Coins"
            }
        }
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var coinAndTimeLabel: UILabel!
    @IBOutlet weak var amountAndCoinsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.makeRoundCorner(8)
    }
}
