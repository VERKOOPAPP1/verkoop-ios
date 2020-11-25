//
//  BannerListCell.swift
//  Verkoop
//
//  Created by Vijay on 31/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class BannerListCell: UITableViewCell {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var expireDateLabel: UILabel!
    @IBOutlet weak var purchaseDateLabel: UILabel!
    @IBOutlet weak var renewButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var bannerDetail: TransactionDetail? {
        didSet {
            if let status = bannerDetail?.status {
                renewButton.isEnabled = false
                renewButton.alpha = 0.3
                if status == 0 {
                    renewButton.alpha = 1.0
                    renewButton.setTitle("Waiting for review", for: .normal)
                } else if status == 1 {
                    renewButton.setAttributedTitle(setUnderlyingString(title: "Renew"), for: .normal)
                } else if status == 2 {
                    renewButton.isEnabled = true
                    renewButton.setAttributedTitle(setUnderlyingString(title: "Renew"), for: .normal)
                } else if status == 3 {
                    renewButton.alpha = 1
                    renewButton.setTitle("Rejected", for: .normal)
                }
            }
            purchaseDateLabel.text = Utilities.sharedUtilities.getFormattedData(dateString: bannerDetail?.updated_at ?? "")
            expireDateLabel.text = Utilities.sharedUtilities.getNextDate(dateString: bannerDetail?.updated_at ?? "", day: bannerDetail?.day ?? 0)
            if let url = URL(string: API.assetsUrl + (bannerDetail?.image ?? "")) {
                bannerImageView.kf.setImage(with: url, placeholder:  UIImage(named: "post_placeholder"))
            } else {
                bannerImageView.image = UIImage(named: "post_placeholder")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        renewButton.setAttributedTitle(setUnderlyingString(title: "Renew"), for: .normal)
        deleteButton.setAttributedTitle(setUnderlyingString(title: "Delete"), for: .normal)
        bannerImageView.layoutIfNeeded()
        bannerImageView.makeRoundCorner(8)
    }
    
    func setUnderlyingString(title: String) -> NSAttributedString{
        let underlineAttribute: [NSAttributedString.Key : Any] = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: kAppDefaultColor]
        return NSAttributedString(string: title, attributes: underlineAttribute)
    }
}
