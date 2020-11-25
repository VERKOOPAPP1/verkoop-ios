//
//  TableCellItemDetail.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 07/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class TableCellItemDetail: UITableViewCell {

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var newUsedImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var CategoryLabel: UILabel!
    @IBOutlet weak var productTypeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }    
}
