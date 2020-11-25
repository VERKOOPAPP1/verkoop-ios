//
//  ReceiverMessageTableCell.swift
//  Verkoop
//
//  Created by Vijay on 09/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class ReceiverMessageTableCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(chat: Chat) {
        messageLabel.text = chat.message?.showEncodedString()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        timeLabel.text = Date.getDateFromTimestamp(timeStamp: chat.timeStamp, formatter: dateFormatter)
        containerView.makeRoundCorner(6)
//        containerView.addShadow(offset: CGSize(width: 1, height: 1), color: .black, radius: 5, opacity: 0.3)
    }
}
