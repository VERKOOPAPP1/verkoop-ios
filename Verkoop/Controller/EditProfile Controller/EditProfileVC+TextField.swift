//
//  EditProfileVC+TextField.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 27/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
import UIKit

extension EditProfileVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let point = textField.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point), let cell = tableView.cellForRow(at: indexPath) as? ProfileTextFieldCell {
            cell.lineView.backgroundColor = kAppDefaultColor
            cell.heightContraint.constant = 1.5
            textField.returnKeyType = .next
            if indexPath.section == 1 && indexPath.row == 1 {
                textField.keyboardType = .phonePad
                textField.doneAccessory = true
            } else {
                textField.keyboardType = .default
                textField.doneAccessory = false
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let point = textField.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point), let cell = tableView.cellForRow(at: indexPath) as? ProfileTextFieldCell {
            switch indexPath.section {
            case 0:
                if indexPath.row == 0 {
                    profileDict[UpdateProfileKeys.username.rawValue] = textField.text
                } else if indexPath.row == 1 {
                    profileDict[UpdateProfileKeys.first_name.rawValue] = String.getString(textField.text)
                } else if indexPath.row == 2 {
                    profileDict[UpdateProfileKeys.last_name.rawValue] = textField.text
                } else if indexPath.row == 3 {
                    profileDict[UpdateProfileKeys.city.rawValue] = textField.text
                } else if indexPath.row == 4 {
                    profileDict[UpdateProfileKeys.website.rawValue] = textField.text
                } else if indexPath.row == 5 {
                    profileDict[UpdateProfileKeys.bio.rawValue] = textField.text
                }
            case 1:
                if indexPath.row == 0 {
                    profileDict[UpdateProfileKeys.email.rawValue] = textField.text
                } else if indexPath.row == 1 {
                    profileDict[UpdateProfileKeys.mobile.rawValue] = textField.text
                }
            default:
                Console.log("Do Nothing")
            }
            
            cell.lineView.backgroundColor = .lightGray
            cell.heightContraint.constant = 1
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let point = textField.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point), let cell = tableView.cellForRow(at: indexPath) as? ProfileTextFieldCell {
            switch indexPath.section {
            case 0:
                if indexPath.row == 5 {
                    let nextIndex = IndexPath(row: 1, section: indexPath.section + 1)
                    if let nextCell = tableView.cellForRow(at: nextIndex) as? ProfileTextFieldCell {
                        nextCell.inputField.becomeFirstResponder()
                    }
                } else if indexPath.row == 2 {
                    let nextIndex = IndexPath(row: indexPath.row + 2, section: indexPath.section)
                    if let nextCell = tableView.cellForRow(at: nextIndex) as? ProfileTextFieldCell {
                        nextCell.inputField.becomeFirstResponder()
                    }
                } else {
                    let nextIndex = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                    if let nextCell = tableView.cellForRow(at: nextIndex) as? ProfileTextFieldCell {
                        nextCell.inputField.becomeFirstResponder()
                    }
                }
            case 1:
                if indexPath.row == 1 {
                    cell.inputField.resignFirstResponder()
                }
            default:
                Console.log("Do Nothing")
            }
        }
        return true
    }
}
