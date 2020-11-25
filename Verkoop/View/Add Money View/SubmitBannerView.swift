//
//  SubmitBannerView.swift
//  Verkoop
//
//  Created by Vijay on 27/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

protocol SubmitBannerDelegate: class {
    func didClosePopup()
}

class SubmitBannerView: UIView {

    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var delegate: SubmitBannerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.makeRoundCorner(8)
        closeButton.makeRoundCorner(closeButton.frame.height / 2)
        containerView.addShadow(offset: CGSize(width: 2, height: 2), color: .black, radius: 5, opacity: 0.5)
        closeButton.addTarget(self, action: #selector(closeButtonAction(_:)), for: .touchUpInside)
    }
    
    @objc func closeButtonAction(_ sender: UIButton) {
        if let delegateObject = delegate {
            delegateObject.didClosePopup()
            animateView(isAnimate: false)
        }
    }
    
    func animateView(isAnimate: Bool) {
        if isAnimate {
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
            }) { (status) in
                self.removeFromSuperview()
            }
        }
    }
}
