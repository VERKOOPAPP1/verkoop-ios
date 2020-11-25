//
//  AddMoneyPopup.swift
//  Verkoop
//
//  Created by Vijay on 27/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

protocol AddMoneyDelegate: class {
    func didMoneyAdded(amount: String)
}

class AddMoneyPopup: UIView {
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var containerView: UIView!    
    
    weak var delegate: AddMoneyDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        containerView.addShadow(offset: CGSize(width: 2, height: 2), color: .black, radius: 3, opacity: 0.5)
        containerView.makeRoundCorner(6)
        proceedButton.setRadius(proceedButton.frame.height / 2, UIColor(hexString: "#E7E7E7"), 1.2)
    }
    
    func animateView(isAnimate: Bool) {
        if isAnimate {
            topConstraint.constant = (kScreenHeight - containerView.frame.height) / 2
            UIView.animate(withDuration: 0.3, animations: {
                self.blurView.alpha = 0.4
                self.layoutIfNeeded()
            })
        } else {
            topConstraint.constant = 900
            UIView.animate(withDuration: 0.3, animations: {
                self.blurView.alpha = 0.0
                self.layoutIfNeeded()
            }) { (status) in
                self.removeFromSuperview()
            }
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        animateView(isAnimate: false)
    }
    
    @IBAction func proceedButtonAction(_ sender: Any) {
        if let delegateObject = delegate, let amount = amountField.text, amount.count > 0 {
            delegateObject.didMoneyAdded(amount: amount)
            animateView(isAnimate: false)
        }
    }
}
