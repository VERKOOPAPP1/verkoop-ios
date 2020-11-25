//
//  FilterVC+ButtonAction.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 04/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
import UIKit

extension FilterVC  {
    @objc func checkButtonAction(_ sender : UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: Int.getInt(sender.accessibilityIdentifier))
        let filterArray = sectionFilter.sectionArray[indexPath.section].filterArray
        switch indexPath.section {
        case 0:
            guard !sender.isSelected else {
                return
            }
            for (index, filter) in filterArray.enumerated() {
                if filter.isSelected && index != indexPath.row {
                    sectionFilter.sectionArray[indexPath.section].filterArray[index].isSelected = false
                    break
                }
            }
            sectionFilter.sectionArray[indexPath.section].filterArray[indexPath.row].isSelected = true
            filterParams[FilterKeys.sort_no.rawValue] = String.getString(sender.tag + 1)
        default:
            sender.isSelected = !sender.isSelected
            filterParams[FilterKeys.meet_up.rawValue] = sender.isSelected ? "1" : ""
            sectionFilter.sectionArray[indexPath.section].filterArray[indexPath.row].isSelected = sender.isSelected
        }
        tableFilterVC.reloadData()
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        filterParams[FilterKeys.latitude.rawValue] = ""
        filterParams[FilterKeys.longitude.rawValue] = ""
        filterParams[FilterKeys.max_price.rawValue] = ""
        filterParams[FilterKeys.min_price.rawValue] = ""
        filterParams[FilterKeys.meet_up.rawValue] = ""
        filterParams[FilterKeys.sort_no.rawValue] = "2"
        
        for (index, _) in sectionFilter.sectionArray[0].filterArray.enumerated() {
            sectionFilter.sectionArray[0].filterArray[index].isSelected = false
        }
        
        sectionFilter.sectionArray[0].filterArray[1].isSelected = true
        sectionFilter.sectionArray[2].filterArray[0].isSelected = false
        if let cell = tableFilterVC.cellForRow(at: IndexPath(row: 0, section: 1)) as? ItemConditionFilterTableCell {
            cell.buttonNew.isSelected = false
            cell.buttonNew.backgroundColor = UIColor(hexString: "#D5D5D5")
            cell.buttonUsed.isSelected = false
            cell.buttonUsed.backgroundColor = UIColor(hexString: "#D5D5D5")
            filterParams[FilterKeys.item_type.rawValue] = ""
        }
        tableFilterVC.reloadData()
    }
    
    @IBAction func applyFilterButtonAction(_ sender: UIButton) {
        if let delegateObject = self.delegate {
            delegateObject.didFiltersApplied(filterParams: self.filterParams)
            navigationController?.popViewController(animated: true)
        }
    }
}
