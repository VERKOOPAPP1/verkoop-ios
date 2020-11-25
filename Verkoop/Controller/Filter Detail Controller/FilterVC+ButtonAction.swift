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

        
        let point = sender.convert(CGPoint.zero, to: tableFilterVC as UIView)
        let indexPath: IndexPath! = tableFilterVC.indexPathForRow(at: point)
        //selectedIndexPath.filter({$0.section == })
        let isIndexPathFound = false
        for (index,selectIndexPath) in selectedIndexPath.enumerated() {
            if selectIndexPath == indexPath {
              isIndexPathFound == true
              selectedIndexPath.remove(at: index)
              break
            }
            else if selectIndexPath.section == indexPath.section {
                selectedIndexPath.remove(at: index)
            }
        }
        if !isIndexPathFound {
          selectedIndexPath.append(indexPath)
        }
        for (index, _) in sectionFilter.sectionArray[indexPath.section].filterArray.enumerated() {
            if index == indexPath.row {
                if sectionFilter.sectionArray[indexPath.section].filterArray[index].isSelected == true {
                    sectionFilter.sectionArray[indexPath.section].filterArray[index].isSelected = false
                    let textData = sectionFilter.sectionArray[indexPath.section].filterArray[index]
                    print(textData)
                    if !arrSetFilterApplied.contains(textData.filterStr) {
                        arrSetFilterApplied.append(textData.filterStr)
                    }
                    else {
                        for (index,value) in arrSetFilterApplied.enumerated() {
                            if value == textData.filterStr {
                              arrSetFilterApplied.remove(at: index)
                            }
                        }
                    }
                }
                else {
                    sectionFilter.sectionArray[indexPath.section].filterArray[index].isSelected = true
                    let textData = sectionFilter.sectionArray[indexPath.section].filterArray[index]
                    print(textData)
                    if !arrSetFilterApplied.contains(textData.filterStr) {
                        arrSetFilterApplied.append(textData.filterStr)
                    }
                    else {
                        for (index,value) in arrSetFilterApplied.enumerated() {
                            if value == textData.filterStr {
                                arrSetFilterApplied.remove(at: index)
                            }
                        }
                    }
                }
            }
            else {
                sectionFilter.sectionArray[indexPath.section].filterArray[index].isSelected = false
                let textData = sectionFilter.sectionArray[indexPath.section].filterArray[indexPath.row]
                print(textData)
            }
        }
        tableFilterVC.reloadData()
        collectionViewFilterCategory.reloadData()
    
    }
    
    
    @objc func tappedNewOld(sender : UIButton!) {
        print("Button New and Old")
        let point = sender.convert(CGPoint.zero, to: tableFilterVC as UIView)
        let indexPath: IndexPath! = tableFilterVC.indexPathForRow(at: point)
        let indexPath1 = IndexPath(row: indexPath.row, section: indexPath.section)
        let cell = tableFilterVC.cellForRow(at: indexPath1)as! ItemConditionFilterTableCell
        if sender.tag == 0 {
            if isCheckNew == true {
                isCheckNew = false
                cell.buttonNew.setImage(UIImage(named:"new_active"), for: .normal)
                cell.buttonNew.setBackgroundImage(UIImage(named: "checkbox_inactive"), for: .normal)
            } else {
                isCheckNew = true
                cell.buttonNew.setImage(UIImage(named:"new_active"), for: .normal)
                cell.buttonNew.setBackgroundImage(UIImage(named: "red_bg"), for: .normal)
            }
            cell.buttonUsed.setImage(UIImage(named:"used_inactive"), for: .normal)
            cell.buttonUsed.setBackgroundImage(UIImage(named: "checkbox_inactive"), for: .normal)
            isCheckUsed = false
        }
        else {
            if isCheckUsed == true {
                isCheckUsed = false
                cell.buttonUsed.setImage(UIImage(named:"used_inactive"), for: .normal)
                cell.buttonUsed.setBackgroundImage(UIImage(named: "checkbox_inactive"), for: .normal)
            }
            else {
                isCheckUsed = true
                cell.buttonUsed.setImage(UIImage(named:"used_active"), for: .normal)
                cell.buttonUsed.setBackgroundImage(UIImage(named: "red_bg"), for: .normal)
            }
            cell.buttonNew.setImage(UIImage(named:"new_active"), for: .normal)
            cell.buttonNew.setBackgroundImage(UIImage(named: "checkbox_inactive"), for: .normal)
            isCheckNew = false
        }
    }
    
    
    @objc func tappedCloseFilter(sender : UIButton!) {
        print("Close")
    }
    
    
}
