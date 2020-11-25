
//
//  AddDetail+TextField.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 05/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
import UIKit

extension AddDetailVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let point = textField.convert(CGPoint.zero, to: tableView as UITableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            if itemType == .generic {
                if indexPath.row == 0 {
                    textField.keyboardType = .default
                    textField.doneAccessory = false
                    textField.autocapitalizationType = .words
                } else {
                    textField.keyboardType = .phonePad
                    textField.doneAccessory = true
                }
            } else if itemType == .car {
                if indexPath.section == 2 { //Year range of car
                    //No Special Change
                } else if indexPath.section == 3 { // Price of car
                    let dollarView = UILabel(frame: CGRect(x: 4, y: 0, width: 15, height: textField.frame.height))
                    dollarView.textColor = kAppDefaultColor
                    dollarView.text = " R"
                    textField.leftViewMode = .always
                    textField.leftView = dollarView
                } else {
                    textField.keyboardType = .default
                    textField.doneAccessory = false
                    textField.autocapitalizationType = .words
                }
            } else if itemType == .property || itemType == .rentals {
                if indexPath.section == 3 { // Price of Property
                    let dollarView = UILabel(frame: CGRect(x: 4, y: 0, width: 15, height: textField.frame.height))
                    dollarView.textColor = kAppDefaultColor
                    dollarView.text = " R"
                    textField.leftViewMode = .always
                    textField.leftView = dollarView
                } else {
                    if indexPath.row == 6 {
                        textField.keyboardType = .phonePad
                        textField.doneAccessory = true
                    } else {
                        textField.keyboardType = .default
                        textField.doneAccessory = false
                        textField.autocapitalizationType = .words
                    }
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let point = textField.convert(CGPoint.zero, to: tableView as UITableView)
        if let indexPath = tableView.indexPathForRow(at: point), itemType == .car, indexPath.section == 2 {
            if let text = textField.text, let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: string)
                if updatedText.count > 4 {
                    return false
                }
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let point = textField.convert(CGPoint.zero, to: tableView as UITableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            if itemType == .generic {
                if indexPath.row == 0 {
                    addDetailDict[AddDetailDictKeys.name.rawValue] = textField.text
                } else if indexPath.row == 3 {
                    addDetailDict[AddDetailDictKeys.price.rawValue] = textField.text
                }
            } else if itemType == .property || itemType == .rentals {
                if indexPath.section == 3 {
                    if textField.tag == 1 {
                        addDetailDict[AddDetailDictKeys.minPrice.rawValue] = textField.text
                    } else {
                        addDetailDict[AddDetailDictKeys.maxPrice.rawValue] = textField.text
                        addDetailDict[AddDetailDictKeys.price.rawValue] = textField.text
                    }
                    if let string =  textField.text, string.isEmpty {
                        textField.leftView = nil
                        textField.leftViewMode = .never
                    }
                } else {
                    if indexPath.row == 0 {
                        addDetailDict[AddDetailDictKeys.name.rawValue] = textField.text
                    } else if indexPath.row == 3 {
                        addDetailDict[AddDetailDictKeys.location.rawValue] = textField.text
                    } else if indexPath.row == 4 {
                        addDetailDict[AddDetailDictKeys.city.rawValue] = textField.text
                    } else if indexPath.row == 5 {
                        addDetailDict[AddDetailDictKeys.street_name.rawValue] = textField.text
                    } else if indexPath.row == 6 {
                        addDetailDict[AddDetailDictKeys.postal_code.rawValue] = textField.text
                    }
                }
            } else if itemType == .car {
                if indexPath.section == 2 {
                    if textField.tag == 1 {
                        addDetailDict[AddDetailDictKeys.fromYear.rawValue] = textField.text
                    } else {
                        addDetailDict[AddDetailDictKeys.toYear.rawValue] = textField.text
                    }
                    if let string =  textField.text, string.isEmpty {
                        textField.leftView = nil
                        textField.leftViewMode = .never
                    }
                } else if indexPath.section == 3 {
                    if textField.tag == 1 {
                        addDetailDict[AddDetailDictKeys.minPrice.rawValue] = textField.text
                    } else {
                        addDetailDict[AddDetailDictKeys.maxPrice.rawValue] = textField.text
                        addDetailDict[AddDetailDictKeys.price.rawValue] = textField.text
                    }
                    if let string =  textField.text, string.isEmpty {
                        textField.leftView = nil
                        textField.leftViewMode = .never
                    }
                } else {
                    if indexPath.row == 0 {
                        addDetailDict[AddDetailDictKeys.name.rawValue] = textField.text
                    } else if indexPath.row == 4 {
                        addDetailDict[AddDetailDictKeys.location.rawValue] = textField.text
                    }
                }
            }
//            self.enableAppyButton()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let point = textField.convert(CGPoint.zero, to: tableView as UITableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            if itemType == .generic {
                if indexPath.row == 0 {
                    let nextIndex = IndexPath(row: indexPath.item + 3, section: indexPath.section)
                    if let cell = tableView.cellForRow(at: nextIndex) as? TableCellSelectCategory {
                        cell.textFieldCatePrice.becomeFirstResponder()
                    }
                } else {
                    textField.resignFirstResponder()
                }
            } else if itemType == .car {
                if indexPath.row == 0 {
                    let nextIndex = IndexPath(row: indexPath.item + 4, section: indexPath.section)
                    if let cell = tableView.cellForRow(at: nextIndex) as? TableCellSelectCategory {
                        cell.textFieldCatePrice.becomeFirstResponder()
                    }
                } else{
                    textField.resignFirstResponder()
                }
            } else if itemType == .property || itemType == .rentals {
                if indexPath.section == 3 {
                     textField.resignFirstResponder()
                } else {
                    if indexPath.row == 0 {
                        let nextIndex = IndexPath(row: indexPath.item + 3, section: indexPath.section)
                        if let cell = tableView.cellForRow(at: nextIndex) as? TableCellSelectCategory {
                            cell.textFieldCatePrice.becomeFirstResponder()
                        }
                    } else if indexPath.row == 3 {
                        let nextIndex = IndexPath(row: indexPath.item + 1, section: indexPath.section)
                        if let cell = tableView.cellForRow(at: nextIndex) as? TableCellSelectCategory {
                            cell.textFieldCatePrice.becomeFirstResponder()
                        }
                    } else {
                        textField.resignFirstResponder()
                    }
                }
            }
        }
        return true
    }
    
    @objc func textFieldChange(_ textField:UITextField) {
        let point = textField.convert(CGPoint.zero, to: tableView as UITableView)
        let indexPath: IndexPath! = tableView.indexPathForRow(at: point)
        if let cell = tableView.cellForRow(at: indexPath) as? TableCellSelectCategory {
            if (cell.textFieldCatePrice.text?.count)! > 0 {
                cell.textFieldCatePrice.textColor = UIColor.getRGBColor(207, g: 33, b: 39)
                cell.viewLineRed.backgroundColor = UIColor.getRGBColor(207, g: 33, b: 39)
            } else {
                cell.textFieldCatePrice.textColor = .lightGray
                cell.viewLineRed.backgroundColor = .lightGray
            }
        }
    }
    
    @objc func categoryButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if !isEdit {
            delay(time: 0.01) {
                let vc = AddSelectCategoryVC.instantiate(fromAppStoryboard: .categories)
                vc.delegate = self
                DispatchQueue.main.async {
                    self.navigationController?.present(vc, animated: false, completion: nil)
                }
            }
        }
    }
    
    @objc func subCategoryButtonAction(_ sender: UIButton) {
        if itemType == .car {
            let selectVC = SelectCityVC()
            selectVC.selectionType = .brandSelection
            navigationController?.pushViewController(selectVC, animated: true)
        } else if itemType == .property || itemType == .rentals {
            let selectVC = SelectCityVC()
            selectVC.selectionType = .subCategorySelection
            navigationController?.pushViewController(selectVC, animated: true)
        }
    }
    
    func enableAppyButton() -> Bool {
        
        guard let _ = addDetailDict[AddDetailDictKeys.image.rawValue] else {
            DisplayBanner.show(message: "Please select atleast one image.")
            return false
        }
        
        guard let name = addDetailDict[AddDetailDictKeys.name.rawValue] as? String, name.count > 0 else {
            DisplayBanner.show(message: "Please enter name")
            return false
        }
        
        guard let category = addDetailDict[AddDetailDictKeys.category_name.rawValue] as? String, category.count > 0 else {
            DisplayBanner.show(message: "Please select category")
            return false
        }
        
        guard let price = addDetailDict[AddDetailDictKeys.price.rawValue] as? String, price.count > 0 else {
            DisplayBanner.show(message: "Please enter price")
            return false
        }
        
        guard let description = addDetailDict[AddDetailDictKeys.description.rawValue] as? String, description.count > 0 else {
            DisplayBanner.show(message: "Please enter description")
            return false
        }
        
        if itemType == .generic { //Generic Validation
            guard let _ = addDetailDict[AddDetailDictKeys.item_type.rawValue] as? String else {
                return false
            }
            
            guard let meetUp = addDetailDict[AddDetailDictKeys.meet_up.rawValue] as? String else {
                return false
            }
            if meetUp == "1" {
                guard let address = addDetailDict[AddDetailDictKeys.address.rawValue] as? String, address.count > 0 else {
                    DisplayBanner.show(message: "Please enter meet up location")
                    return false
                }
            }
        } else if itemType == .car { //Car Validation
            guard let brand = addDetailDict[AddDetailDictKeys.brand_name.rawValue] as? String, brand.count > 0 else {
                DisplayBanner.show(message: "Please enter car brand")
                return false
            }
            
            guard let location = addDetailDict[AddDetailDictKeys.location.rawValue] as? String, location.count > 0 else {
                DisplayBanner.show(message: "Please enter location")
                return false
            }
            
            guard let minYear = addDetailDict[AddDetailDictKeys.fromYear.rawValue] as? String, let maxYear = addDetailDict[AddDetailDictKeys.toYear.rawValue] as? String, minYear.count == 4, maxYear.count == 4 else {
                DisplayBanner.show(message: "Please enter registration year")
                return false
            }
            
            guard let minPrice = addDetailDict[AddDetailDictKeys.minPrice.rawValue] as? String, let maxPrice = addDetailDict[AddDetailDictKeys.maxPrice.rawValue] as? String, minPrice.count > 0, maxPrice.count > 0 else {
                DisplayBanner.show(message: "Please enter price range")
                return false
            }
            
            guard let owner = addDetailDict[AddDetailDictKeys.direct_owner.rawValue] as? String, owner.count > 0  else {
                return false
            }
        } else if itemType == .property || itemType == .rentals { //Property Validation
            guard let zone = addDetailDict[AddDetailDictKeys.location.rawValue] as? String, zone.count > 0 else {
                DisplayBanner.show(message: "Please enter zone")
                return false
            }
            
            guard let street = addDetailDict[AddDetailDictKeys.street_name.rawValue] as? String, street.count > 0 else {
                DisplayBanner.show(message: "Please enter street name")
                return false
            }
            
            guard let postal = addDetailDict[AddDetailDictKeys.postal_code.rawValue] as? String, postal.count > 0 else {
                DisplayBanner.show(message: "Please enter postal code")
                return false
            }
            
            guard let area = addDetailDict[AddDetailDictKeys.city.rawValue] as? String, area.count > 0 else {
                DisplayBanner.show(message: "Please enter city or province")
                return false
            }
            
            guard let bedroom = addDetailDict[AddDetailDictKeys.bedroom.rawValue] as? String, bedroom.count > 0 else {
                DisplayBanner.show(message: "Please enter number of bedroom")
                return false
            }
            
            guard let bathroom = addDetailDict[AddDetailDictKeys.bathroom.rawValue] as? String, bathroom.count > 0 else {
                DisplayBanner.show(message: "Please enter number of bathroom")
                return false
            }
            
            guard let minPrice = addDetailDict[AddDetailDictKeys.minPrice.rawValue] as? String, let maxPrice = addDetailDict[AddDetailDictKeys.maxPrice.rawValue] as? String, minPrice.count > 0, maxPrice.count > 0 else {
                DisplayBanner.show(message: "Please enter price range")
                return false
            }
            
            guard let owner = addDetailDict[AddDetailDictKeys.direct_owner.rawValue] as? String, owner.count > 0  else {
                return false
            }
        }
        return true
    }
}

extension AddDetailVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let text = addDetailDict[AddDetailDictKeys.description.rawValue] as? String {
            if text.isEmpty || text == textViewPlaceholder {
                textView.text = textViewPlaceholder
                textView.textColor = .lightGray
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
                textView.setContentOffset(.zero, animated: true)
            } else {
                textView.text = text
                textView.textColor = kAppDefaultColor
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        if updatedText.isEmpty {
            addDetailDict[AddDetailDictKeys.description.rawValue] = updatedText
            textView.text = textViewPlaceholder
            textView.textColor = .lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            textView.setContentOffset(.zero, animated: true)
        } else if textView.textColor == .lightGray && !text.isEmpty {
            textView.textColor = kAppDefaultColor
            textView.text = text
        } else {
            return true
        }
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == .lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let text = textView.text , !text.isEmpty , text.removingWhitespaces() != textViewPlaceholder.removingWhitespaces() {
            addDetailDict[AddDetailDictKeys.description.rawValue] = text
        }
    }
}
