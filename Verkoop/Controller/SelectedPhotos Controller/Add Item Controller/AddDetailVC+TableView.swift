//
//  AddDetailVC+TableView.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 05/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

extension AddDetailVC: UITableViewDataSource , UITableViewDelegate {
    
    //MARK:- UITableView Delegates and Datasource
    //MARK:-
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if itemType == .generic {
            return genericSection.count
        } else if itemType == .car {
            return carSection.count
        } else if itemType == .property || itemType == .rentals {
            return propertySection.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemType == .generic {
            if section == 1 {
                return genericSectionPlaceholder.count
            } else {
                return 1
            }
        } else if itemType == .car {
            if section == 1 {
                return carSectionPlaceholder.count
            } else {
                return 1
            }
        } else if itemType == .property || itemType == .rentals {
            if section == 1 {
                return propertySectionPlaceholder.count
            } else if section == 2 {
                return 2
            } else {
                return 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.tableCellSelectedPhotos, for: indexPath) as? TableCellSelectedPhotos else {
                return UITableViewCell()
            }
            cell.collectionSelectedPhoto.delegate = self
            cell.collectionSelectedPhoto.dataSource = self
            cell.collectionSelectedPhoto.reloadData()
            return cell
        } else if indexPath.section == tableView.numberOfSections - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.TextViewCell, for: indexPath) as! TextViewCell
            cell.textView.delegate = self
            if let description = addDetailDict[AddDetailDictKeys.description.rawValue] as? String , !description.isEmpty , description.removingWhitespaces() != textViewPlaceholder.removingWhitespaces() {
                cell.textView.textColor = UIColor(hexString: "#9A9A9B")
                cell.textView.text = addDetailDict[AddDetailDictKeys.description.rawValue] as? String
            } else {
                cell.textView.textColor = .lightGray
                cell.textView.text = "Describe what you are selling and include any detail a buyer might be intrested in. People love item what stories"
            }
            return cell
        } else if indexPath.section == 1 && indexPath.row <= 2 { //COMMON FOR ALL SECTION
            if indexPath.row == 1 { //MOBILE
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.MobileTableCell, for: indexPath) as? MobileTableCell else {
                    return UITableViewCell()
                }
                if Constants.sharedUserDefaults.getUserMobile() == "" {
                    cell.mobileNumberButton.setTitle("Mobile", for: .normal)
                    cell.mobileNumberButton.setTitleColor(.lightGray, for: .normal)
                    cell.lineView.backgroundColor = .lightGray
                    cell.changeEditLabel.text = "Update"
                } else {
                    cell.mobileNumberButton.setTitle(Constants.sharedUserDefaults.getUserMobile(), for: .normal)
                    cell.mobileNumberButton.setTitleColor(kAppDefaultColor, for: .normal)
                    cell.lineView.backgroundColor = kAppDefaultColor
                    cell.changeEditLabel.text = "Change"
                }
                cell.mobileNumberButton.addTarget(self, action: #selector(changeMobileButtonAction(_:)), for: .touchUpInside)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.tableCellSelectCategory, for: indexPath) as? TableCellSelectCategory else {
                    return UITableViewCell()
                }
                cell.textFieldCatePrice.placeholder = genericSectionPlaceholder[indexPath.row]
                cell.textFieldCatePrice.leftView = nil
                cell.textFieldCatePrice.leftViewMode = .never
                cell.textFieldCatePrice.returnKeyType = .next
                
                if indexPath.row == 0 { //NAME
                    cell.buttonDropDown.isHidden = true
                    cell.textFieldCatePrice.isUserInteractionEnabled = true
                    cell.textFieldCatePrice.delegate = self
                    cell.textFieldCatePrice.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
                    if let textString = addDetailDict[AddDetailDictKeys.name.rawValue] as? String, textString.count > 0 {
                        cell.textFieldCatePrice.textColor = UIColor.getRGBColor(207, g: 33, b: 39)
                        cell.viewLineRed.backgroundColor = UIColor.getRGBColor(207, g: 33, b: 39)
                    } else {
                        cell.textFieldCatePrice.textColor = UIColor.lightGray
                        cell.viewLineRed.backgroundColor = UIColor.lightGray
                    }
                    cell.textFieldCatePrice.text = addDetailDict[AddDetailDictKeys.name.rawValue] as? String ?? ""
                    cell.textFieldCatePrice.returnKeyType = .next
                } else if indexPath.row == 2 {//CATEGORY
                    cell.buttonDropDown.isHidden = false
                    cell.textFieldCatePrice.isUserInteractionEnabled = false
                    cell.textFieldCatePrice.textColor = kAppDefaultColor
                    cell.textFieldCatePrice.text = addDetailDict[AddDetailDictKeys.category_name.rawValue] as? String ?? ""
                    cell.buttonDropDown.addTarget(self, action: #selector(categoryButtonAction(_:)), for: .touchUpInside)
                }
                return cell
            }
        } else if itemType == .generic { // UPTO HERE COMMON FOR ALL SECTION
            //MARK:- Generic Section
            switch indexPath.section {
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.tableCellSelectCategory, for: indexPath) as? TableCellSelectCategory else {
                    return UITableViewCell()
                }
                cell.textFieldCatePrice.placeholder = genericSectionPlaceholder[indexPath.row]
                cell.buttonDropDown.isHidden = true
                cell.textFieldCatePrice.isUserInteractionEnabled = true
                cell.textFieldCatePrice.delegate = self
                cell.textFieldCatePrice.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
                if let textString = addDetailDict[AddDetailDictKeys.price.rawValue] as? String, textString.count > 0 {
                    cell.textFieldCatePrice.textColor = UIColor.getRGBColor(207, g: 33, b: 39)
                    cell.viewLineRed.backgroundColor = UIColor.getRGBColor(207, g: 33, b: 39)
                } else {
                    cell.textFieldCatePrice.textColor = UIColor.lightGray
                    cell.viewLineRed.backgroundColor = UIColor.lightGray
                }
                cell.textFieldCatePrice.text = addDetailDict[AddDetailDictKeys.price.rawValue] as? String ?? ""
                let dollarView = UILabel(frame: CGRect(x: 4, y: 0, width: 13, height: cell.textFieldCatePrice.frame.height))
                dollarView.textColor = kAppDefaultColor
                dollarView.font = UIFont.kAppDefaultFontBold(ofSize: 18)
                dollarView.text = "R"
                cell.textFieldCatePrice.leftViewMode = .always
                cell.textFieldCatePrice.leftView = dollarView
                cell.textFieldCatePrice.returnKeyType = .done
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.itemConditionFilterTableCell, for: indexPath)as! ItemConditionFilterTableCell
                cell.delegate = self
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.TitleAndCheckBoxCell, for: indexPath) as! TitleAndCheckBoxCell
                cell.titleLabel.text = "Meet-up"
                cell.checkButton.isHidden = false
                if let meetUp = addDetailDict[AddDetailDictKeys.meet_up.rawValue] as? String, meetUp == "1" {
                    cell.checkButton.isSelected = true
                } else {
                    cell.checkButton.isSelected = false
                }
                cell.checkButton.addTarget(self, action: #selector(checkButtonTapped(_:)), for: .touchUpInside)
                return cell
                
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.TitleAndCheckBoxCell, for: indexPath) as! TitleAndCheckBoxCell
                cell.checkButton.isHidden = true
                if let address = addDetailDict[AddDetailDictKeys.address.rawValue] as? String , !address.isEmpty {
                    cell.titleLabel.text = address
                    cell.titleLabel.textColor = kAppDefaultColor
                } else {
                    cell.titleLabel.text = "Your meet up location and schedule"
                    cell.titleLabel.textColor = .darkGray
                }
                return cell
                
            default:
                return UITableViewCell()
            }
        } else if itemType == .car {
            //MARK:- Car Section
            switch indexPath.section {
            case 2: //Registration Year
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.priceTableCell, for: indexPath) as? PriceTableCell else {
                    return UITableViewCell()
                }
                cell.firstLabel.text = "From"
                cell.secondLabel.text = "To"
                cell.lineView.backgroundColor = .lightGray
                cell.minimumPriceField.delegate = self
                cell.maximumPriceField.delegate = self
                cell.minimumPriceField.text = addDetailDict[AddDetailDictKeys.fromYear.rawValue] as? String ?? ""
                cell.maximumPriceField.text = addDetailDict[AddDetailDictKeys.toYear.rawValue] as? String ?? ""
                return cell
            case 3: //Price Cell
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.priceTableCell, for: indexPath) as? PriceTableCell else {
                    return UITableViewCell()
                }
                cell.firstLabel.text = "Min"
                cell.secondLabel.text = "Max"
                cell.lineView.backgroundColor = .lightGray
                cell.minimumPriceField.delegate = self
                cell.maximumPriceField.delegate = self
                cell.minimumPriceField.text = addDetailDict[AddDetailDictKeys.minPrice.rawValue] as? String ?? ""
                cell.maximumPriceField.text = addDetailDict[AddDetailDictKeys.maxPrice.rawValue] as? String ?? ""
                return cell
            default:
                if indexPath.row == 6 {//TRANSMISSION TYPE
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ParkingTableCell, for: indexPath) as? ParkingTableCell else {
                        return UITableViewCell()
                    }
                    cell.cellType = .transmission
                    cell.firstButton.setTitle("Manual", for: .normal)
                    cell.secondButton.setTitle("Automatic", for: .normal)
                    cell.delegate = self
                    return cell

                } else if indexPath.row == 5 { //PRIVATE OR AGENT
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ParkingTableCell, for: indexPath) as? ParkingTableCell else {
                        return UITableViewCell()
                    }
                    cell.cellType = .ownerShip
                    cell.firstButton.setTitle("Private", for: .normal)
                    cell.secondButton.setTitle("Dealership", for: .normal)
                    cell.delegate = self
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.tableCellSelectCategory, for: indexPath) as? TableCellSelectCategory else {
                        return UITableViewCell()
                    }
                    
                    cell.textFieldCatePrice.placeholder = carSectionPlaceholder[indexPath.row]
                    cell.textFieldCatePrice.leftView = nil
                    cell.textFieldCatePrice.leftViewMode = .never
                    cell.textFieldCatePrice.returnKeyType = .next
                    cell.buttonDropDown.isHidden = true
                    cell.textFieldCatePrice.isUserInteractionEnabled = true
                    cell.textFieldCatePrice.delegate = self
                    cell.textFieldCatePrice.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
                    
                    if indexPath.row == 3 { //BRAND
                        cell.buttonDropDown.isHidden = false
                        cell.textFieldCatePrice.isUserInteractionEnabled = false
                        cell.textFieldCatePrice.textColor = kAppDefaultColor
                        if let text = addDetailDict[AddDetailDictKeys.brand_name.rawValue] as? String , text.count > 0 , let body = addDetailDict[AddDetailDictKeys.model_name.rawValue] as? String, body.count > 0 {
                            cell.textFieldCatePrice.text = text + " (\(body))"
                        } else {
                            cell.textFieldCatePrice.text =  ""
                        }
                        cell.buttonDropDown.addTarget(self, action: #selector(subCategoryButtonAction(_:)), for: .touchUpInside)
                    } else if indexPath.row == 4 { //PROVINCE
                        if let textString = addDetailDict[AddDetailDictKeys.location.rawValue] as? String, textString.count > 0 {
                            cell.textFieldCatePrice.textColor = UIColor.getRGBColor(207, g: 33, b: 39)
                            cell.viewLineRed.backgroundColor = UIColor.getRGBColor(207, g: 33, b: 39)
                            cell.textFieldCatePrice.text = textString
                        } else {
                            cell.textFieldCatePrice.textColor = UIColor.lightGray
                            cell.viewLineRed.backgroundColor = UIColor.lightGray
                            cell.textFieldCatePrice.text = ""
                        }
                        cell.textFieldCatePrice.returnKeyType = .done
                    }
                    return cell
                }
            }
        } else if itemType == .property || itemType == .rentals {
            //MARK:- Property Section
            //MARK:-
            if indexPath.section == 2 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.BedroomBathroomCell, for: indexPath) as? BedroomBathroomCell else {
                    return UITableViewCell()
                }
                cell.increaseButton.layoutIfNeeded()
                cell.decreaseButton.layoutIfNeeded()
                cell.increaseButton.roundCorners(corners: [.bottomRight, .topRight], radius: 22)
                cell.decreaseButton.roundCorners(corners: [.topLeft, .bottomLeft], radius: 22)
                cell.decreaseButton.tag = indexPath.row
                cell.increaseButton.tag = indexPath.row
                
                cell.increaseButton.addTarget(self, action: #selector(increaseButonAction(_:)), for: .touchUpInside)
                cell.decreaseButton.addTarget(self, action: #selector(decreaseButonAction(_:)), for: .touchUpInside)
                
                if indexPath.row == 0 {
                    cell.titleLabel.text = "Bedroom"
                    if let bedroom = addDetailDict[AddDetailDictKeys.bedroom.rawValue] as? String, bedroom.count > 0 {
                        cell.counterLabel.text = bedroom
                    } else {
                        cell.counterLabel.text = "0"
                    }
                    cell.lineView.backgroundColor = .white
                } else {
                    cell.titleLabel.text = "Bathroom"
                    if let bathroom = addDetailDict[AddDetailDictKeys.bathroom.rawValue] as? String, bathroom.count > 0 {
                        cell.counterLabel.text = bathroom
                    } else {
                        cell.counterLabel.text = "0"
                    }
                    cell.lineView.backgroundColor = .lightGray
                }
                return cell
            } else if indexPath.section == 3 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.priceTableCell, for: indexPath) as? PriceTableCell else {
                    return UITableViewCell()
                }
                cell.firstLabel.text = "Min"
                cell.secondLabel.text = "Max"
                cell.lineView.backgroundColor = .lightGray
                cell.minimumPriceField.delegate = self
                cell.maximumPriceField.delegate = self
                cell.minimumPriceField.text = addDetailDict[AddDetailDictKeys.minPrice.rawValue] as? String ?? ""
                cell.maximumPriceField.text = addDetailDict[AddDetailDictKeys.maxPrice.rawValue] as? String ?? ""
                return cell
            } else if indexPath.section == 4 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.PropertyTypeCell, for: indexPath) as? PropertyTypeCell else {
                    return UITableViewCell()
                }
                if let type = addDetailDict[AddDetailDictKeys.property_type.rawValue] as? String {
                    cell.setSelectedButton(propertyType: type)
                } else {
                    cell.setSelectedButton(propertyType: "House")
                }
                cell.delegate = self
                return cell
            } else if indexPath.section == 5 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.SwitchCell, for: indexPath) as? SwitchCell else {
                    return UITableViewCell()
                }
                if let owner = addDetailDict[AddDetailDictKeys.direct_owner.rawValue] as? String , owner == "2" {
                    cell.directSwitch.isOn = true
                } else {
                    cell.directSwitch.isOn = false
                }
                
                cell.directSwitch.addTarget(self, action: #selector(directSwitchAction(_:)), for: .valueChanged)
                return cell
            } else {
                if indexPath.row == 7 || indexPath.row == 8 { //PARKING
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ParkingTableCell, for: indexPath) as? ParkingTableCell else {
                        return UITableViewCell()
                    }
                    if indexPath.row == 7 {
                        if let type = addDetailDict[AddDetailDictKeys.parking_type.rawValue] as? String {
                            if type == "1" {
                                cell.parkingImageView.image = #imageLiteral(resourceName: "checkbox_active")
                                cell.garageImageView.image = #imageLiteral(resourceName: "checkbox_inactive")
                            } else {
                                cell.garageImageView.image = #imageLiteral(resourceName: "checkbox_active")
                                cell.parkingImageView.image = #imageLiteral(resourceName: "checkbox_inactive")
                            }
                        } else {
                            cell.parkingImageView.image = #imageLiteral(resourceName: "checkbox_active")
                            cell.garageImageView.image = #imageLiteral(resourceName: "checkbox_inactive")
                        }
                        cell.cellType = .parking
                        cell.firstButton.setTitle("Parking", for: .normal)
                        cell.secondButton.setTitle("Garage", for: .normal)
                    } else {
                        if let type = addDetailDict[AddDetailDictKeys.furnished.rawValue] as? String {
                            if type == "1" {
                                cell.parkingImageView.image = #imageLiteral(resourceName: "checkbox_active")
                                cell.garageImageView.image = #imageLiteral(resourceName: "checkbox_inactive")
                            } else {
                                cell.garageImageView.image = #imageLiteral(resourceName: "checkbox_active")
                                cell.parkingImageView.image = #imageLiteral(resourceName: "checkbox_inactive")
                            }
                        } else {
                            cell.parkingImageView.image = #imageLiteral(resourceName: "checkbox_active")
                            cell.garageImageView.image = #imageLiteral(resourceName: "checkbox_inactive")
                        }
                        cell.cellType = .furnished
                        cell.firstButton.setTitle("Furnished", for: .normal)
                        cell.secondButton.setTitle("Unfurnished", for: .normal)
                    }
                    cell.delegate = self
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.tableCellSelectCategory, for: indexPath) as? TableCellSelectCategory else {
                        return UITableViewCell()
                    }
                    cell.textFieldCatePrice.placeholder = propertySectionPlaceholder[indexPath.row]
                    cell.textFieldCatePrice.leftView = nil
                    cell.textFieldCatePrice.leftViewMode = .never
                    cell.textFieldCatePrice.returnKeyType = .next
                    cell.buttonDropDown.isHidden = true
                    cell.textFieldCatePrice.isUserInteractionEnabled = true
                    cell.textFieldCatePrice.delegate = self
                    cell.textFieldCatePrice.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
                    
                    if indexPath.row == 6 { //Postal Code
                        if let textString = addDetailDict[AddDetailDictKeys.postal_code.rawValue] as? String, textString.count > 0 {
                            cell.textFieldCatePrice.textColor = UIColor.getRGBColor(207, g: 33, b: 39)
                            cell.viewLineRed.backgroundColor = UIColor.getRGBColor(207, g: 33, b: 39)
                        } else {
                            cell.textFieldCatePrice.textColor = UIColor.lightGray
                            cell.viewLineRed.backgroundColor = UIColor.lightGray
                        }
                        cell.textFieldCatePrice.text = addDetailDict[AddDetailDictKeys.postal_code.rawValue] as? String ?? ""
                    } else {
                        if indexPath.row == 3 {//Province
                            if let street = addDetailDict[AddDetailDictKeys.location.rawValue] as? String, street.count > 0 {
                                cell.textFieldCatePrice.textColor = UIColor.getRGBColor(207, g: 33, b: 39)
                                cell.viewLineRed.backgroundColor = UIColor.getRGBColor(207, g: 33, b: 39)
                                cell.textFieldCatePrice.text = street
                            } else {
                                cell.textFieldCatePrice.textColor = UIColor.lightGray
                                cell.viewLineRed.backgroundColor = UIColor.lightGray
                                cell.textFieldCatePrice.text = ""
                            }
                        } else if indexPath.row == 4 {//City
                            if let street = addDetailDict[AddDetailDictKeys.city.rawValue] as? String, street.count > 0 {
                                cell.textFieldCatePrice.textColor = UIColor.getRGBColor(207, g: 33, b: 39)
                                cell.viewLineRed.backgroundColor = UIColor.getRGBColor(207, g: 33, b: 39)
                                cell.textFieldCatePrice.text = street
                            } else {
                                cell.textFieldCatePrice.textColor = UIColor.lightGray
                                cell.viewLineRed.backgroundColor = UIColor.lightGray
                                cell.textFieldCatePrice.text = ""
                            }
                        }  else if indexPath.row == 5 {//Streat Name
                            if let street = addDetailDict[AddDetailDictKeys.street_name.rawValue] as? String, street.count > 0 {
                                cell.textFieldCatePrice.textColor = UIColor.getRGBColor(207, g: 33, b: 39)
                                cell.viewLineRed.backgroundColor = UIColor.getRGBColor(207, g: 33, b: 39)
                                cell.textFieldCatePrice.text = street
                            } else {
                                cell.textFieldCatePrice.textColor = UIColor.lightGray
                                cell.viewLineRed.backgroundColor = UIColor.lightGray
                                cell.textFieldCatePrice.text = ""
                            }
                        }
                    }
                    return cell //Property Section
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        } else if indexPath.section == tableView.numberOfSections - 1 {
            return 100
        } else if itemType == .generic {
            if indexPath.section == 2 {
                return kScreenHeight * 0.18
            } else if indexPath.section == 4 {
                return 60
            }
        } else if itemType == .car {
            //No Special Case Height is required
        } else if itemType == .property || itemType == .rentals {
            if indexPath.section == 2 {
                return 56
            } else if indexPath.section == 4 {
                return 150
            } else if indexPath.row == 8  {
                return (itemType == .rentals) ? 50 : 0
            }
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if itemType == .generic {
            if indexPath.section == 4 && indexPath.section != tableView.numberOfSections - 1 {
                LocationManager.shairedInstance.delegate = self
                LocationManager.shairedInstance.locationRequest()
            }
        }
    }
    
    //MARK:- UITableView Header Delegates and Datasource
    //MARK:-
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if itemType == .generic {
            return section == 0 ? genericSection[section] + " \(photoAsset.count)/10" : genericSection[section]
        } else if itemType == .car {
            return section == 0 ? carSection[section] + " \(photoAsset.count)/10" : carSection[section]
        } else if itemType == .property || itemType == .rentals {
            return section == 0 ? propertySection[section] + " \(photoAsset.count)/10" : propertySection[section]
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if itemType == .generic {
            if section == 1 {
                return 0
            } else {
                return 40
            }
        } else if itemType == .car {
            if section == 1 {
                return 0
            } else {
                return 40
            }
        } else if itemType == .property || itemType == .rentals {
            if section == 1 || section == 2 {
                return 0
            } else {
                return 40
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.tintColor = UIColor.white
            headerView.textLabel?.textColor = UIColor(hexString: "#686868")
            headerView.textLabel?.font = UIFont.kAppDefaultFontBold(ofSize: 17)
        }
    }
    
    //MARK:- Private Functions
    //MARK:-
    
    @objc func checkButtonTapped(_ sender: UIButton) {
        if sender.isSelected {
            isSelectLocation = false
            sender.isSelected = false
            genericSection.remove(at: 4)
            addDetailDict[AddDetailDictKeys.meet_up.rawValue] = "0"
        } else {
            isSelectLocation = true
            sender.isSelected = true
            genericSection.insert("Location", at: 4)
            addDetailDict[AddDetailDictKeys.meet_up.rawValue] = "1"
        }
        tableView.reloadData()
        if sender.isSelected {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 4), at: .middle, animated: true)
        }
//        enableAppyButton()
    }
    
    @objc func increaseButonAction(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 2)
        guard let cell = tableView.cellForRow(at: indexPath) as? BedroomBathroomCell else {
            return
        }
        let count = Int.getInt(cell.counterLabel.text)
        cell.counterLabel.text = String.getString(count + 1)
        if indexPath.row == 0 {
            addDetailDict[AddDetailDictKeys.bedroom.rawValue] = String.getString(count + 1)
        } else {
            addDetailDict[AddDetailDictKeys.bathroom.rawValue] = String.getString(count + 1)
        }
//        enableAppyButton()
    }
    
    @objc func decreaseButonAction(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 2)
        guard let cell = tableView.cellForRow(at: indexPath) as? BedroomBathroomCell else {
            return
        }
        let count = Int.getInt(cell.counterLabel.text)
        if count > 0 {
            cell.counterLabel.text = String.getString(count - 1)
            if indexPath.row == 0 {
                addDetailDict[AddDetailDictKeys.bedroom.rawValue] = String.getString(count - 1)
            } else {
                addDetailDict[AddDetailDictKeys.bathroom.rawValue] = String.getString(count - 1)
            }
        }
//        enableAppyButton()
    }
    
    @objc func directSwitchAction(_ sender: UISwitch) {
        sender.isOn = !sender.isOn
        addDetailDict[AddDetailDictKeys.direct_owner.rawValue] = sender.isOn ? "2" : "1"
//        enableAppyButton()
    }
    
    @objc func changeMobileButtonAction(_ sender: UISwitch) {
        let mobileVC = ChangeMobileVC.instantiate(fromAppStoryboard: .registration)
        mobileVC.delegate = self
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(mobileVC, animated: true)
        }
    }
    
}
