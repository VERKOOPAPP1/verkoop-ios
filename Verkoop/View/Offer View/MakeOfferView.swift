//
//  MakeOfferView.swift
//  Verkoop
//
//  Created by Vijay on 08/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

@objc protocol MakeOfferDelegate {
    func didClickMakeOfferButton(price: String)
    @objc optional func removeFromSuperView()
}

class MakeOfferView: UIView {
    
    @IBOutlet weak var makeOfferButton: UIButton!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!
    
    var delegate: MakeOfferDelegate?
    var userOffer = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        priceField.delegate = self
        buttonBottomConstraint.constant = -(kScreenHeight * 0.1 + 45.0)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self) else { return }
        if blurView.frame.contains(location) {
            animateView(isAnimate: false)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if let animationCurveInt = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue {
                let animationCurve = UIView.AnimationOptions(rawValue: animationCurveInt<<16)
                if #available(iOS 11.0, *) {
                    animateOnKeyboardAppear(height: keyboardSize.height - 50 - safeAreaInsets.bottom, option: animationCurve)
                } else {
                    // Fallback on earlier versions
                    animateOnKeyboardAppear(height: keyboardSize.height - 50, option: animationCurve)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if let animationCurveInt = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue {
            let animationCurve = UIView.AnimationOptions(rawValue: animationCurveInt<<16)
            animateOnKeyboardAppear(height: 0, option:animationCurve)
        }
    }
    
    func animateView(isAnimate: Bool) {
        if isAnimate {                        
            buttonBottomConstraint.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.blurView.alpha = 0.4
                self.layoutIfNeeded()
            }
        } else {
            buttonBottomConstraint.constant = -(kScreenHeight * 0.1 + 45.0)
            UIView.animate(withDuration: 0.2, animations: {
                self.blurView.alpha = 0
                self.layoutIfNeeded()
            }) { (status) in
                if status {
                    if let delegateObject = self.delegate {
                        delegateObject.removeFromSuperView?()
                    }
                    self.removeFromSuperview()
                }
            }
        }
    }
    
    func animateOnKeyboardAppear(height: CGFloat, option: UIView.AnimationOptions) {
        bottomContraint.constant = height
        UIView.animate(withDuration: 0.15, delay: 0, options: option, animations: {
             self.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func makeOfferButtonAction(_ sender: UIButton) {
        if let delegateObject = delegate {
            delegateObject.didClickMakeOfferButton(price: priceField.text ?? "")
            animateView(isAnimate: false)
        }
    }
}
