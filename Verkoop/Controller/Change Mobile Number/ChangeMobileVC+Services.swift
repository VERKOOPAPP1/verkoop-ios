//
//  ChangeMobileVC+Services.swift
//  Verkoop
//
//  Created by Vijay on 07/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension ChangeMobileVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if updatedText.isEmpty {
                lineView.backgroundColor = .lightGray
            } else {
                lineView.backgroundColor = kAppDefaultColor
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func requestOTPService() {
        let endPoint = MethodName.requestOTP + "/" + Constants.sharedUserDefaults.getUserId()
        ApiManager.request(path:endPoint, parameters: ["mobile_no":(countryCodeButton.titleLabel?.text!)! + mobileField.text!], methodType: .put) { [weak self](result) in
            switch result {
            case .success(let data):
                if let _: GenericResponse = self?.handleSuccess(data: data) {
                    DispatchQueue.main.async {
                        DisplayBanner.show(message: "An OTP has been sent to this mobile number. Please verify it.")
                        self?.showPopup()
                    }
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }    
    
    func submitOTPRequest(otpString: String) {
        let endPoint = MethodName.verifyMobile
        ApiManager.request(path:endPoint,
            parameters: ["otp": otpString,
                         "user_id": Constants.sharedUserDefaults.getUserId(),
                         "mobile_no":(countryCodeButton.titleLabel?.text!)! + mobileField.text!], methodType: .post) { [weak self](result) in
            switch result {
            case .success(let data):
                if let response: GenericResponse = self?.handleSuccess(data: data) {
                    if let delegateObject = self?.delegate {
                        Constants.sharedUserDefaults.set(self?.mobileField.text!, forKey: UserDefaultKeys.kUserMobile)
                        delegateObject.didMobileNumberVerified()
                        DispatchQueue.main.async {
                            DisplayBanner.show(message: response.message)
                            self?.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
    
    func showPopup() {
        if let otpView = Bundle.main.loadNibNamed(ReuseIdentifier.OTPVerificationView, owner: self, options: nil)?.first as? OTPVerificationView {
            otpView.frame = view.frame
            otpView.delegate = self
            view.addSubview(otpView)
            otpView.showView(animate: true)
        }
    }
}
