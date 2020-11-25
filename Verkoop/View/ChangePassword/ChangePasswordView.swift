//
//  ChangePasswordView.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 27/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class ChangePasswordView: UIView {
    
    var delegate: ChangePasswordDelegates?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var blurEffectView: UIView!
    @IBOutlet weak var currentPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var initialFrame: CGRect!
    var activeField: UITextField?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    fileprivate func initialSetup() {
        containerView.layoutIfNeeded()
        initialFrame = containerView.frame
        currentPasswordField.delegate = self
        newPasswordField.delegate = self
        confirmPasswordField.delegate = self
        
        blurEffectView.alpha = 0.42
        saveButton.setRadius(saveButton.frame.height / 2, .white, 1)
        containerView.setRadius(10)
        containerView.addShadow(offset: CGSize(width: 5, height: 5), color: .darkGray, radius: 5, opacity: 0.7)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            initialFrame = containerView.frame
            containerView.frame = CGRect(x:initialFrame.origin.x , y: initialFrame.origin.y - keyboardSize.height/2 , width: initialFrame.width, height: initialFrame.height)
            UIView.animate(withDuration: 0.3) {
                self.containerView.layoutIfNeeded()
                self.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        containerView.frame = initialFrame
        UIView.animate(withDuration: 0.2) {
            self.containerView.layoutIfNeeded()
            self.layoutIfNeeded()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self) else { return }
        if !containerView.frame.contains(location) {
            endEditing(true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        
        guard let currentPassword = currentPasswordField.text , !currentPassword.isEmpty  else {
            DisplayBanner.show(message: "Enter Current Password")
            return
        }
        
        if currentPassword != Constants.sharedUserDefaults.getCurrentPassword() {
            DisplayBanner.show(message: "Wrong old password")
            return
        }
        
        guard let newPassword = newPasswordField.text , !newPassword.isEmpty  else {
            DisplayBanner.show(message: "Enter New Password")
            return
        }
        
        if !newPassword.isLengthValid(minLength: 6, maxLength: 50) {
            DisplayBanner.show(message: Validation.errorPasswordLengthInvalid)
            return
        }
        
        guard let newConfirmPassword = confirmPasswordField.text , !newConfirmPassword.isEmpty  else {
            DisplayBanner.show(message: "Enter Confirm Password")
            return
        }
        
        if newPassword != newConfirmPassword {
            DisplayBanner.show(message: "Password Mismatch")
            return
        }
        
        if let delegateObject = delegate {
            delegateObject.requestChangePassword!(view: self, param: ["user_id":"1",
                "current_password":Constants.sharedUserDefaults.getCurrentPassword(),
                "new_password":newPassword])
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        if let delegateObject = delegate {
            delegateObject.cancelChangePassword!(view: self)
        }
    }
}

@objc protocol ChangePasswordDelegates {
   @objc optional func cancelChangePassword(view: ChangePasswordView)
    @objc optional func requestChangePassword(view: ChangePasswordView, param: [String: String])
}

/*
 let frame = self.convert(keyboardSize, from: nil)
 if frame.intersects(activeField.frame) {
 initialFrame = containerView.frame
 containerView.frame = CGRect(x:initialFrame.origin.x , y: initialFrame.origin.y - keyboardSize.height/2 , width: initialFrame.width, height: initialFrame.height)
 UIView.animate(withDuration: 0.3) {
 self.containerView.layoutIfNeeded()
 self.layoutIfNeeded()
 }
 }

 */
