//
//  OTPVerificationView+TextField.swift
//  Verkoop
//
//  Created by Vijay on 07/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension OTPVerificationView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if !updatedText.isEmpty {
                if textField.text?.count == 0 {
                    perform(#selector(changeTextFieldFocusToNext(_:)), with: textField, afterDelay: 0.0)
                } else {
                    perform(#selector(changeTextFieldFocusToBack(_:)), with: textField, afterDelay: 0.0)
                }
                return true
            }
        }
        return false
    }
    
    @objc func changeTextFieldFocusToBack(_ textField: UITextField?) {
        if textField?.tag == 4 {
            thirdField.becomeFirstResponder()
        } else if textField?.tag == 3 {
            secondField.becomeFirstResponder()
        } else if textField?.tag == 2 {
            firstField.becomeFirstResponder()
        }
    }

    @objc func changeTextFieldFocusToNext(_ textField: UITextField?) {
        if textField?.tag == 4 {
            endEditing(true)
        } else if textField?.tag == 1 {
            secondField.becomeFirstResponder()
        } else if textField?.tag == 2 {
            thirdField.becomeFirstResponder()
        } else if textField?.tag == 3 {
            fourthField.becomeFirstResponder()
        }
    }
}
