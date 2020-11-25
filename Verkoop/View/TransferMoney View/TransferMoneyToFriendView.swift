//
//  TransferMoneyToFriend.swift
//  Verkoop
//
//  Created by Vijay on 01/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

protocol TransferMoneyDelegate: class {
    func transferMoneyService(coin: String)
}

class TransferMoneyToFriendView: UIView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coinField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    weak var delegate: TransferMoneyDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.makeRoundCorner(6)
        containerView.addShadow(offset: CGSize(width: 4, height: 5), color: .black, radius: 5, opacity: 0.6)
        sendButton.makeRoundCorner(sendButton.frame.height/2)
        profileImageView.makeRoundCorner(profileImageView.frame.height/2)
        cancelButton.addTarget(self, action: #selector(closeButtonAction(_:)), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendButtonAction(_:)), for: .touchUpInside)
    }
    
    func setData(info: FriendDetail) {
        nameLabel.text = "Send money to" + "\n" + (info.username ?? "")
        if let url = URL(string: API.assetsUrl + (info.profile_pic ?? "")) {
            profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "pic_placeholder"))
        } else {
            profileImageView.image = UIImage(named: "pic_placeholder")
        }
    }
    
    func showView(animate: Bool) {
        if animate == true {
            containerView.alpha = 0.4
            containerView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            UIView.animate(withDuration: 0.5, animations: {
                self.containerView.transform = .identity
                self.containerView.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.containerView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                self.containerView.alpha = 0.0
            }, completion: { (status) in
                self.delegate = nil
                self.removeFromSuperview()
            })
        }
    }
    
    @objc func sendButtonAction(_ sender: UIButton) {
        if let delegateObject = delegate, let coin = coinField.text {
            delegateObject.transferMoneyService(coin: coin)
            showView(animate: false)
        }
    }
    
    @objc func closeButtonAction(_ sender: UIButton) {
        showView(animate: false)
    }
    
    deinit {
        Console.log("Transfer View is Deinitialized")
    }
    
}
