//
//  RateUserView.swift
//  Verkoop
//
//  Created by Vijay on 29/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit
import FloatRatingView

protocol RateUserDelegate: class {
    func didRateUser(rating: String)
}

class RateUserView: UIView {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var starRatingView: FloatRatingView!
    @IBOutlet weak var ratingUserLabel: UILabel!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    weak var delegate: RateUserDelegate?
        
    override func awakeFromNib() {
        super.awakeFromNib()        
        containerView.makeRoundCorner(6)
        containerView.addShadow(offset: CGSize(width: 5, height: 5), color: .black, radius: 10, opacity: 0.65)
        submitButton.makeRoundCorner(25)
        cancelButton.addTarget(self, action: #selector(twoButtonAction(_:)), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(twoButtonAction(_:)), for: .touchUpInside)
    }

    deinit {
        Console.log("Rate User View has been destroyed")
    }
    
    @objc func twoButtonAction(_ sender: UIButton) {
        if sender.tag == 1 {
            animateView(isAnimate: false)
        } else {
            if let delegateObject = delegate {
                delegateObject.didRateUser(rating: String.getString(starRatingView.rating))
                animateView(isAnimate: false)
            }
        }
    }
    
    func animateView(isAnimate: Bool) {
        if isAnimate {
            topConstraint.constant = (kScreenHeight - containerView.frame.height) / 2
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.25, animations: {
                    self.blurView.alpha = 0.4
                    self.layoutIfNeeded()
                })
            }
        } else {
            topConstraint.constant = 900
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.25, animations: {
                    self.blurView.alpha = 0.0
                    self.layoutIfNeeded()
                }) { (status) in
                    self.removeFromSuperview()
                }
            }
        }
    }
}
