//
//  ReceiverOfferTableCell.swift
//  Verkoop
//
//  Created by Vijay on 14/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class ReceiverOfferTableCell: UITableViewCell {

    @IBOutlet weak var offerTitleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(chat: Chat) {
        if chat.messageType == "2" {
            offerTitleLabel.text = "MADE AN OFFER "
        } else if chat.messageType == "3" {
            offerTitleLabel.text = "ACCEPTED OFFER "
        } else if chat.messageType == "4" {
            offerTitleLabel.text = "DECLINED OFFER "
        } else if chat.messageType == "5" {
            offerTitleLabel.text = "CANCELLED OFFER "
        }
        messageLabel.text =  "R " + (chat.message?.showEncodedString() ?? "0")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        timeLabel.text = Date.getDateFromTimestamp(timeStamp: chat.timeStamp, formatter: dateFormatter)
        containerView.makeRoundCorner(6)
//        containerView.addShadow(offset: CGSize(width: 1, height: 1), color: .black, radius: 5, opacity: 0.3)
    }
}
