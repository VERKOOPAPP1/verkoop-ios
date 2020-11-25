//
//  MakeOfferView+TextField.swift
//  Verkoop
//
//  Created by Vijay on 08/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension MakeOfferView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text , !text.isEmpty , (userOffer <= Double.getDouble(text)) {
            makeOfferButton.isEnabled = true
            makeOfferButton.setTitleColor(.white, for: .normal)
        } else {
            makeOfferButton.isEnabled = false
            makeOfferButton.setTitleColor(UIColor(hexString: "#C1C1C1"), for: .normal)
            DispatchQueue.main.async {
                DisplayBanner.show(message: "The bid should be higher than R  \(String.getString(self.userOffer))")
            }
        }        
    }
}
