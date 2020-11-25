//
//  SelectCityVC+TableViewDelegates.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 28/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension SelectCityVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectionType == .regionSelection {
            return isStateList ? searchedStateArray.count : searchedCityArray.count
        } else if selectionType == .brandSelection {
            return isBrandList ? (searchedCategoryList?.data?.count ?? 0) : (searchedCategoryList?.data![mainCategorySelectedIndex].car_models?.count ?? 0)
        } else if selectionType == .subCategorySelection {
            return zoneArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.TitleAndCheckBoxCell, for: indexPath) as? TitleAndCheckBoxCell else {
            return UITableViewCell()
        }
        
        if selectionType == .regionSelection {
            if isStateList {
                cell.titleLabel.text = searchedStateArray[indexPath.row].name
                if indexPath.row == mainCategorySelectedIndex {
                    cell.checkButton.isSelected = true
                } else {
                    cell.checkButton.isSelected = false
                }
            } else {
                cell.titleLabel.text = searchedCityArray[indexPath.row].name
                if indexPath.row == subCategorySelectedIndex {
                    cell.checkButton.isSelected = true
                } else {
                    cell.checkButton.isSelected = false
                }
            }
        } else if selectionType == .brandSelection {
            if isBrandList {
                cell.titleLabel.text = searchedCategoryList?.data![indexPath.row].name
                if indexPath.row == mainCategorySelectedIndex {
                    cell.checkButton.isSelected = true
                } else {
                    cell.checkButton.isSelected = false
                }
            } else {
                let carModel = searchedCategoryList?.data![mainCategorySelectedIndex].car_models![indexPath.row]                
                cell.titleLabel.text = carModel?.name
                if indexPath.row == subCategorySelectedIndex {
                    cell.checkButton.isSelected = true
                } else {
                    cell.checkButton.isSelected = false
                }
            }
        } else {
            cell.titleLabel.text = zoneArray[indexPath.row]["name"]
        }
        
        cell.checkButton.tag = indexPath.row
        cell.checkButton.removeTarget(self, action: #selector(checkButtonAction(_:)), for: .touchUpInside)
        cell.checkButton.addTarget(self, action: #selector(checkButtonAction(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func checkButtonAction(_ sender: UIButton) {
        
        if selectionType == .regionSelection {
            if isStateList {
                if let cell = tableView.cellForRow(at: IndexPath(row: subCategorySelectedIndex, section: 0)) as? TitleAndCheckBoxCell {
                    cell.checkButton.isSelected = false
                }
                mainCategorySelectedIndex = sender.tag
                let selectVC = SelectCityVC()
                selectVC.selectionType = .regionSelection
                selectVC.isStateList = false
                selectVC.stateArray = stateArray
                selectVC.countryID = countryID
                selectVC.countryName = countryName
                selectVC.mainCategorySelectedIndex = sender.tag
                sender.isSelected = true
                navigationController?.pushViewController(selectVC, animated: true)
                delay(time: 0.5) {
                    self.tableView.reloadData()
                }
            } else {
                if let viewController = navigationController?.viewControllers, viewController.count > 0 {
                    for controller in viewController {
                        if controller.isKind(of: EditProfileVC.self) {
                            let userInfo = ["city_id": String.getString(searchedCityArray[sender.tag].id), "city_name": String.getString(searchedCityArray[sender.tag].name), "state_id": String.getString(stateArray[mainCategorySelectedIndex].id), "state_name": String.getString(stateArray[mainCategorySelectedIndex].name), "country_id": countryID, "country_name": countryName]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.GetSelectedCity), object: nil, userInfo: userInfo)
                            delay(time: 0.2) {
                                self.navigationController?.popToViewController(controller, animated: true)
                            }
                        }
                    }
                }
            }
        } else if selectionType == .brandSelection {
            if isBrandList {
                if let cell = tableView.cellForRow(at: IndexPath(row: subCategorySelectedIndex, section: 0)) as? TitleAndCheckBoxCell {
                    cell.checkButton.isSelected = false
                }
                mainCategorySelectedIndex = sender.tag
                let selectVC = SelectCityVC()
                selectVC.isBrandList = false
                selectVC.categoryList = categoryList
                selectVC.searchedCategoryList = searchedCategoryList
                selectVC.selectionType = .brandSelection
                selectVC.mainCategorySelectedIndex = sender.tag
                sender.isSelected = true
                navigationController?.pushViewController(selectVC, animated: true)
                delay(time: 0.5) {
                    self.tableView.reloadData()
                }
            } else {
                if let viewController = navigationController?.viewControllers, viewController.count > 0 {
                    for controller in viewController {
                        if controller.isKind(of: AddDetailVC.self) {
                            let carDetail = searchedCategoryList?.data![mainCategorySelectedIndex]
                            let userInfo = ["brand_id":                                String.getString(carDetail?.id),
                                           "brand_name": String.getString(carDetail?.name),
                                           "model_id": String.getString(carDetail?.car_models![sender.tag].id),
                                           "model_name": String.getString(carDetail?.car_models![sender.tag].name)]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.GetSelectedBrand), object: nil, userInfo: userInfo)
                            DispatchQueue.main.async {
                                self.navigationController?.popToViewController(controller, animated: true)
                            }
                        }
                    }
                }
            }
        } else {
            if let viewController = navigationController?.viewControllers, viewController.count > 0 {
                for controller in viewController {
                    if controller.isKind(of: AddDetailVC.self) {
                        let userInfo = ["zone_id": zoneArray[sender.tag]["id"], "zone_name": zoneArray[sender.tag]["name"]]
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.GetSelectedZone), object: nil, userInfo: userInfo as [AnyHashable: Any])
                        DispatchQueue.main.async {
                            self.navigationController?.popToViewController(controller, animated: true)
                        }
                    }
                }
            }
        }
    }
}
