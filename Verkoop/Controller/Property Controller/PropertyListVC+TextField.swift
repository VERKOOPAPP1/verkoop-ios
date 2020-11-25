//
//  PropertyListVC+TextField.swift
//  Verkoop
//
//  Created by Vijay on 18/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension PropertyListVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let searchVC = SearchVC()        
        navigationController?.pushViewController(searchVC, animated: true)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
