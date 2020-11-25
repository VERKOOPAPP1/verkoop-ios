//
//  CategoryFilterVC+Delegates.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 30/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

protocol ApplyFilterDelegates {
    func didFiltersApplied(filterParams : Dictionary<String, String>)
}

extension FilterVC: AddDetailDelegate {
    func selectUsedUnusedType(isNew: Int) {
        if isNew == 1 {
            filterParams[FilterKeys.item_type.rawValue] = String.getString(isNew)
        } else {
            filterParams[FilterKeys.item_type.rawValue] = String.getString(isNew)
        }
    }
}

extension FilterVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let dollarView = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: textField.frame.height))
        dollarView.textColor = kAppDefaultColor
        dollarView.text = "R "
        textField.leftViewMode = .always
        textField.leftView = dollarView
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let point = textField.convert(CGPoint.zero, to: tableFilterVC)
        if let indexPath = tableFilterVC.indexPathForRow(at: point) {
            guard let cell = tableFilterVC.cellForRow(at: indexPath) as? PriceTableCell else {
                return
            }
            if textField == cell.minimumPriceField {
                filterParams[FilterKeys.min_price.rawValue] = textField.text
            } else {
                filterParams[FilterKeys.max_price.rawValue] = textField.text
            }
        }
        if let string =  textField.text, string.isEmpty {
            textField.leftView = nil
            textField.leftViewMode = .never
        }
    }
}
