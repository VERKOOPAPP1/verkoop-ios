//
//  SenderImageTableCell.swift
//  Verkoop
//
//  Created by Vijay on 07/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class SenderImageTableCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var senderImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        senderImageView.setRadius(8, .white, 2.5)
    }
    
    func setData(chat: Chat) {
        if let url = URL(string: API.assetsUrl + (chat.message ?? "")) {
            senderImageView.kf.setImage(with: url, placeholder:  UIImage(named: ""))
        } else {
            senderImageView.image = UIImage(named: "")
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        timeLabel.text = Date.getDateFromTimestamp(timeStamp: chat.timeStamp, formatter: dateFormatter)
    }
}
