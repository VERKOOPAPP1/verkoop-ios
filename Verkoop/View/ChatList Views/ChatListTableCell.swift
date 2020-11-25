//
//  ChatListTableCell.swift
//  Verkoop
//
//  Created by Vijay on 09/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit
import FloatRatingView

class ChatListTableCell: UITableViewCell {

    @IBOutlet weak var starRatingView: FloatRatingView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingContainerView: UIView!
    @IBOutlet weak var aceptedLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var acceptedWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var soldLabel: UILabel!
    @IBOutlet weak var unreadCountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var acceptedLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(lastChat: LastChat) {
        usernameLabel.text = lastChat.username
        unreadCountLabel.text = "\(lastChat.unreadCount)"
        unreadCountLabel.isHidden = lastChat.unreadCount == 0 ? true : false
        productNameLabel.text = lastChat.item_name
        soldLabel.isHidden = lastChat.is_sold == 1 ? false : true
        acceptedLabel.isHidden = false
        acceptedWidthConstraint.constant = 75
        aceptedLabelHeightConstraint.constant = 30
        ratingContainerView.isHidden = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        timeLabel.text = Date.getDateFromTimestamp(timeStamp: lastChat.timeStamp, formatter: dateFormatter)
        
        if lastChat.messageType == "0" {
            messageLabel.text = lastChat.message?.jsonStringRedecoded
        } else if lastChat.messageType == "1" {
            messageLabel.text = "📷 Image"
        } else if lastChat.messageType == "6" {
            ratingContainerView.isHidden = false
            ratingLabel.text = lastChat.message?.jsonStringRedecoded
            starRatingView.rating = Double.getDouble(ratingLabel.text)
            messageLabel.text = ""
        } else {
            messageLabel.text =  "R " + (lastChat.message?.jsonStringRedecoded ?? "0.0")
        }
        
        if String.getString(lastChat.userId) == Constants.sharedUserDefaults.getUserId() {
            priceLabel.text = "Offered you $\(lastChat.offer_price)"
            if lastChat.offer_status == 0 {//Offer is made to this Seller
                acceptedWidthConstraint.constant = 0
            } else if lastChat.offer_status == 1 { //Offer Accepted by this seller
                acceptedLabel.text = " Accepted "
                acceptedLabel.backgroundColor = UIColor(hexString: "#67CA4C")
            } else if lastChat.offer_status == 2 {//Offer Rejected by this Seller
                acceptedLabel.text = " Declined "
                acceptedLabel.backgroundColor = kAppDefaultColor
            } else {//No Action
                aceptedLabelHeightConstraint.constant = 0
                acceptedWidthConstraint.constant = 0
            }
        } else {
            priceLabel.text = "You offered $\(lastChat.offer_price)"
            if lastChat.offer_status == 0 {//Offer Made by this Buyer
                acceptedWidthConstraint.constant = 0
            } else if lastChat.offer_status == 1 && lastChat.is_sold == 1{//Item is sold to this User
                acceptedLabel.text = " Accepted "
                acceptedLabel.backgroundColor = UIColor(hexString: "#67CA4C")
            } else if lastChat.offer_status == 2 {
                acceptedLabel.text = " Declined "
                acceptedLabel.backgroundColor = kAppDefaultColor
            } else {//No Action
                aceptedLabelHeightConstraint.constant = 0
                acceptedWidthConstraint.constant = 0
            }
        }
        layoutIfNeeded()
        
        if let url = URL(string: API.assetsUrl + (lastChat.profilePhoto ?? "")) {
            profileImage.kf.setImage(with: url, placeholder:  UIImage(named: "pic_placeholder"))
            } else {
            profileImage.image = UIImage(named: "pic_placeholder")
        }

        if let url = URL(string: API.assetsUrl + (lastChat.productImage ?? "")) {
            productImage.kf.setImage(with: url, placeholder:  UIImage(named: "post_placeholder"))
        } else {
            productImage.image = UIImage(named: "post_placeholder")
        }
        
        profileImage.layoutIfNeeded()
        profileImage.makeRoundCorner(25)
    }
    
}
