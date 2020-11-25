//
//  UserRatingTableCell.swift
//  Verkoop
//
//  Created by Vijay on 12/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit
import FloatRatingView

class UserRatingTableCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var starRatingView: FloatRatingView!
    @IBOutlet weak var showProfileButton: UIButton!
    @IBOutlet weak var showItemButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.makeRoundCorner(6)
        backView.addShadow(offset: CGSize(width: 1, height: 1), color: .darkGray, radius: 2, opacity: 0.1)
        profileImageView.makeRoundCorner(profileImageView.frame.height / 2)
    }
    
    func setData(userRating: UserRatingDetail) {
        nameLabel.text = userRating.userName
        itemNameLabel.text = userRating.name
        dateLabel.text = Utilities.sharedUtilities.getFormattedData(dateString: userRating.created_at ?? "")
        starRatingView.rating = Double.getDouble(userRating.rating)
        if let profileUrl = URL(string: API.assetsUrl + (userRating.profile_pic ?? "")) {
            profileImageView.kf.setImage(with: profileUrl)
        } else {
            profileImageView.image = UIImage(named: "")
        }
        
        if let itemUrl = URL(string: API.assetsUrl + (userRating.url ?? "")) {
            itemImageView.kf.setImage(with: itemUrl)
        } else {
            itemImageView.image = UIImage(named: "")
        }
    }
}
