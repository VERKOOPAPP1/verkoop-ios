//
//  CustomDatePickerView.swift
//  Verkoop
//
//  Created by Vijay on 16/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

@objc protocol DatePickerDelegates {
    @objc optional func didPickedDate(dateString: String)
}

class CustomDatePickerView: UIView {
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var customDatePicker: UIDatePicker!
    
    var delegate: DatePickerDelegates?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        customDatePicker.maximumDate = Date()
        containerView.makeRoundCorner(8)
        containerView.addShadow(offset: CGSize(width: 5, height: 5), color: .black, radius: 10, opacity: 0.65)        
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        animateView(isAnimate: false)
    }
    
    @IBAction func okButtonAction(_ sender: UIButton) {
        if let delegateObject = delegate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let selectedTime = formatter.string(from: customDatePicker.date)
            delegateObject.didPickedDate?(dateString: selectedTime)
            animateView(isAnimate: false)
        }
    }

    func animateView(isAnimate: Bool) {
        if isAnimate {
            topConstraint.constant = kScreenHeight * 0.65 / 2
            UIView.animate(withDuration: 0.25, animations: {
                self.blurView.alpha = 0.4
                self.layoutIfNeeded()
            })
        } else {
            topConstraint.constant = kScreenHeight
            UIView.animate(withDuration: 0.15, animations: {
                self.blurView.alpha = 0.0
                self.layoutIfNeeded()
            }) { (status) in
                self.removeFromSuperview()
            }
        }
    }
}
