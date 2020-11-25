//
//  ChangeMobileVC+Protocols.swift
//  Verkoop
//
//  Created by Vijay on 11/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

protocol MobileNumberVerifiedDelegate: class {
    func didMobileNumberVerified()
}

extension ChangeMobileVC: CountryCodeDelegate {
    func didSelectCountryCode(dialCode: String) {
        DispatchQueue.main.async {
            self.countryCodeButton.setTitle(dialCode, for: .normal)
        }
    }
}

extension ChangeMobileVC: MobileVerificationDelegate {
    func didOTPEntered(otpString: String) {
        submitOTPRequest(otpString: otpString)
    }
    
    func resendOTP() {
        requestOTPService()
    }
}
