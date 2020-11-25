//
//  SenderRateTableCell.swift
//  Verkoop
//
//  Created by Vijay on 11/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit
import FloatRatingView

class SenderRateTableCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var starRatingView: FloatRatingView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.makeRoundCorner(6)
    }
    
    func setData(chatObject: Chat) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        timeLabel.text = Date.getDateFromTimestamp(timeStamp: chatObject.timeStamp, formatter: dateFormatter)
        starRatingView.rating = Double.getDouble(chatObject.message)
    }
}
