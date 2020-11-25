
//
//  PriceTableCell.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 01/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class PriceTableCell: UITableViewCell {

    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var maximumPriceField: UITextField!
    @IBOutlet weak var minimumPriceField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
