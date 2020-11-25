//
//  SelectLocation+TextFieldDelegates.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 29/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension SelectMeetupLocationVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let searchString = textField.text {
            getSearchedLocation(searchString: searchString)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
