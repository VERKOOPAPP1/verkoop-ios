//
//  TransactionHistoryCell.swift
//  Verkoop
//
//  Created by Vijay on 27/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class TransactionHistoryCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var transactionTypeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    var walletHistory = true
    
    var dataModel: TransactionDetail? {
        didSet {
            profileImageView.contentMode = .center
            if !walletHistory {
                if let url = URL(string: API.assetsUrl + (dataModel?.profilePic ?? "")) {
                    profileImageView.kf.setImage(with: url, placeholder:  UIImage(named: "pic_placeholder"))
                } else {
                    profileImageView.image = UIImage(named: "balance")
                }
                
                if dataModel?.type == 0 {
                    amountLabel.textColor = kAppGreenColor
                    amountLabel.text =  "+ " + String.getString(dataModel?.coin) + " Coins"
                    profileImageView.image = UIImage(named: "balance")
                    transactionTypeLabel.text = "Added to Verkoop"
                } else if dataModel?.type == 1 {
                    amountLabel.textColor = .black
                    profileImageView.image = UIImage(named: "balance")
                    amountLabel.text =  "- " + String.getString(dataModel?.coin) + " Coins"
                    transactionTypeLabel.text = "Purchased Advertise"
                } else if dataModel?.type == 2 {
                    amountLabel.textColor = .black
                    amountLabel.text =  "- " + String.getString(dataModel?.coin) + " Coins"
                    profileImageView.contentMode = .scaleAspectFill
                    transactionTypeLabel.text = "Sent to \((dataModel?.userName ?? "User"))"
                } else {
                    amountLabel.textColor = kAppGreenColor
                    amountLabel.text =  "+ " + String.getString(dataModel?.coin) + " Coins"
                    profileImageView.contentMode = .scaleAspectFill
                    transactionTypeLabel.text = "Received from \((dataModel?.userName ?? ""))"
                }
            } else {
                profileImageView.image = UIImage(named: "balance")
                if dataModel?.type == 0 {
                    amountLabel.text = "+ R" + String.getString(dataModel?.amount)
                    amountLabel.textColor = kAppGreenColor
                    transactionTypeLabel.text = "Added to Wallet"
                } else if dataModel?.type == 1 {
                    amountLabel.text = "- R" + String.getString(dataModel?.amount)
                    amountLabel.textColor = .black
                    profileImageView.contentMode = .scaleAspectFill
                    transactionTypeLabel.text = "Sent to \((dataModel?.userName ?? "User"))"
                    if let url = URL(string: API.assetsUrl + (dataModel?.profilePic ?? "")) {
                        profileImageView.kf.setImage(with: url, placeholder:  UIImage(named: "pic_placeholder"))
                    } else {
                        profileImageView.image = UIImage(named: "balance")
                    }
                }
            }
            timeLabel.text = Utilities.sharedUtilities.getTimeDifference(dateString: String.getString(dataModel?.created_at), isFullFormat: true)
            if let status = dataModel?.status {
                statusLabel.text = status == 0 ? "Failure" : "Success"
            } else {
                statusLabel.text = "Success"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.makeRoundCorner(5)
        profileImageView.makeRoundCorner(profileImageView.frame.height/2)
        backView.addShadow(offset: CGSize(width: 1.5, height: 1.5), color: .darkGray, radius: 3, opacity: 0.25)
    }
}
