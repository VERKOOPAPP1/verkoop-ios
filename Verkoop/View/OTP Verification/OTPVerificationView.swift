//
//  OTPVerificationView.swift
//  Verkoop
//
//  Created by Vijay on 07/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

protocol MobileVerificationDelegate: class {
    func didOTPEntered(otpString: String)
    func resendOTP()
}

class OTPVerificationView: UIView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var resendButton: UIButton!    
    @IBOutlet weak var firstField: UITextField!
    @IBOutlet weak var secondField: UITextField!
    @IBOutlet weak var thirdField: UITextField!
    @IBOutlet weak var fourthField: UITextField!    
    
    weak var delegate: MobileVerificationDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        firstField.delegate = self
        secondField.delegate = self
        thirdField.delegate = self
        fourthField.delegate = self
        containerView.makeRoundCorner(6)
        containerView.addShadow(offset: CGSize(width: 4, height: 5), color: .black, radius: 5, opacity: 0.6)
        resendButton.setRadius(resendButton.frame.height/2, kAppDefaultColor, 1.5)
        sendButton.makeRoundCorner(sendButton.frame.height/2)
        resendButton.addTarget(self, action: #selector(resendButtonAction(_:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(closeButtonAction(_:)), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendButtonAction(_:)), for: .touchUpInside)
    }
    
    func showView(animate: Bool) {
        if animate == true {
            containerView.alpha = 0.4
            containerView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            UIView.animate(withDuration: 0.5, animations: {
                self.containerView.transform = CGAffineTransform.identity
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
        if (firstField.text?.count ?? 0) > 0 && (secondField.text?.count ?? 0) > 0 && (thirdField.text?.count ?? 0) > 0 && (fourthField.text?.count ?? 0) > 0 {
            if let delegateObject = delegate {
                delegateObject.didOTPEntered(otpString: firstField.text! + secondField.text! + thirdField.text! + fourthField.text!)
                showView(animate: false)
            }
        } else {
            DisplayBanner.show(message: "Please Enter OTP")
        }
    }
    
    @objc func resendButtonAction(_ sender: UIButton) {
        if let delegateObject = delegate {
            delegateObject.resendOTP()
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
