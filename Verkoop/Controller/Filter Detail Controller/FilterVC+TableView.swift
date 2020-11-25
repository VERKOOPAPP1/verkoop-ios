
//
//  FilterVC+TableView.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 04/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
import UIKit

extension FilterVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionFilter.sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionFilter.sectionArray[section].filterArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView =  UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
        headerView.backgroundColor = UIColor.white
        let headerTitle = UILabel(frame: CGRect(x: 10, y: 2, width: tableView.frame.width - 20, height: 50))
        headerTitle.textColor = UIColor.darkGray
        headerTitle.font = UIFont.kAppDefaultFontBold(ofSize: 18.0)
        headerTitle.backgroundColor = .clear
        headerTitle.text = sectionFilter.sectionArray[section].section
        headerView.addSubview(headerTitle)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 45.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let filterData = sectionFilter.sectionArray[indexPath.section].filterArray[indexPath.row]
        
        switch indexPath.section {
        case 0,2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.TitleAndCheckBoxCell, for: indexPath) as? TitleAndCheckBoxCell else  {
                return UITableViewCell()
            }
            cell.checkButton.isSelected = filterData.isSelected
            cell.checkButton.isHidden = false
            cell.checkButton.tag = indexPath.row
            cell.checkButton.accessibilityIdentifier = String.getString(indexPath.section)
            cell.titleLabel.text = filterData.filterStr
            cell.checkButton.addTarget(self, action: #selector(checkButtonAction(_:)), for: .touchUpInside)
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.itemConditionFilterTableCell, for: indexPath) as? ItemConditionFilterTableCell else {
                return UITableViewCell()
            }
            
            if filterParams[FilterKeys.item_type.rawValue] == "1" {
                cell.buttonNew.isSelected = true
                cell.buttonNew.backgroundColor = kAppDefaultColor
                cell.buttonUsed.isSelected = false
                cell.buttonUsed.backgroundColor = UIColor(hexString: "#D5D5D5")
            } else if filterParams[FilterKeys.item_type.rawValue] == "2" {
                cell.buttonNew.isSelected = false
                cell.buttonNew.backgroundColor = UIColor(hexString: "#D5D5D5")
                cell.buttonUsed.isSelected = true
                cell.buttonUsed.backgroundColor = kAppDefaultColor
            } else {
                cell.buttonNew.isSelected = false
                cell.buttonNew.backgroundColor = UIColor(hexString: "#D5D5D5")
                cell.buttonUsed.isSelected = false
                cell.buttonUsed.backgroundColor = UIColor(hexString: "#D5D5D5")
            }
            cell.delegate = self
            return cell

        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.priceTableCell, for: indexPath) as? PriceTableCell else {
                return UITableViewCell()
            }
            cell.minimumPriceField.delegate = self
            cell.maximumPriceField.delegate = self            
            cell.minimumPriceField.text = filterParams[FilterKeys.min_price.rawValue] ?? ""
            cell.maximumPriceField.text = filterParams[FilterKeys.max_price.rawValue] ?? ""
            return cell

        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0,2,3:
            return kScreenHeight*0.08
        case 1:
            return 120
        default:
            return 0
        }
    }
}




