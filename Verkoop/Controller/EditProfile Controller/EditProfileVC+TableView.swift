//
//  EditProfileVC+TableViewDelegates.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 26/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
import UIKit

extension EditProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView =  UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
        headerView.backgroundColor = UIColor.white
        let label = UILabel(frame: CGRect(x: 10, y: 2, width: tableView.frame.width - 20, height: 50))
        label.textColor = UIColor.lightGray
        label.font = UIFont.kAppDefaultFontRegular(ofSize: 18.0)
        label.backgroundColor = UIColor.white
        label.text = sectionData[section]
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return firstSection.count
        } else if section == 1 {
            return secondSection.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == firstSection.count - 1 {
                return 86
            } else {
                return 50
            }
        } else if indexPath.section == 1 {
            return indexPath.row == tableView.numberOfRows(inSection: 1) - 1 ? 60 : 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        switch indexPath.section {
        case 0:
            if indexPath.row == firstSection.count - 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ProfilePhotoCell, for: indexPath) as? ProfilePhotoCell else {
                    return UITableViewCell()
                }
                
                if let selectedImage = userImage {
                    cell.profileImage.image = selectedImage
                } else if let urlString = profileDict[UpdateProfileKeys.profile_pic.rawValue] as? String, !urlString.isEmpty {
                    if let url = URL(string: API.assetsUrl + urlString) {
                        cell.profileImage.kf.setImage(with: url, placeholder: UIImage(named: "pic_placeholder"))
                    } else {
                        cell.profileImage.image =  UIImage(named: "pic_placeholder")
                    }
                } else {
                    cell.profileImage.image = UIImage(named: "pic_placeholder")
                }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ProfileTextFieldCell, for: indexPath) as? ProfileTextFieldCell else {
                    return UITableViewCell()
                }
                cell.changeMobileButton.isHidden = true
                cell.inputField.delegate = self
                cell.title.text = firstSection[indexPath.row]
                cell.inputField.placeholder = firstSection[indexPath.row]
                
                if indexPath.row == 0 {
                    cell.inputField.text =  profileDict[UpdateProfileKeys.username.rawValue] as? String ?? ""
                } else if indexPath.row == 1 {
                    cell.inputField.text = profileDict[UpdateProfileKeys.first_name.rawValue] as? String ?? ""
                } else if indexPath.row == 2 {
                    cell.inputField.text = profileDict[UpdateProfileKeys.last_name.rawValue] as? String ?? ""
                } else if indexPath.row == 3 {
                    cell.inputField.text = (profileDict[UpdateProfileKeys.state.rawValue] as? String)! + ", " + (profileDict[UpdateProfileKeys.city.rawValue] as? String)!
                } else if indexPath.row == 4 {
                    cell.inputField.text = profileDict[UpdateProfileKeys.website.rawValue] as? String ?? ""
                } else if indexPath.row == 5 {
                    cell.inputField.text = profileDict[UpdateProfileKeys.bio.rawValue] as? String ?? ""
                }
                
                if indexPath.row == 3 {
                    cell.inputField.isUserInteractionEnabled = false
                } else {
                    cell.inputField.isUserInteractionEnabled = true
                }
                return cell
            }
        case 1:
            
            if indexPath.row == 0 || indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ProfileTextFieldCell, for: indexPath) as? ProfileTextFieldCell else {
                    return UITableViewCell()
                }
                cell.inputField.delegate = self
                cell.inputField.placeholder = secondSection[indexPath.row]
                cell.title.text = secondSection[indexPath.row]
                
                if indexPath.row == 0 {
                    cell.inputField.text = profileDict[UpdateProfileKeys.email.rawValue] as? String ?? ""
                    cell.inputField.isUserInteractionEnabled = false
                    cell.changeMobileButton.isHidden = true
                } else if indexPath.row == 1 {
                    if let text = profileDict[UpdateProfileKeys.mobile.rawValue] as? String, text.count > 0 {
                        cell.inputField.text = text
                        cell.changeMobileButton.setTitle("Change", for: .normal)
                    } else {
                        cell.inputField.text = ""
                        cell.changeMobileButton.setTitle("Update", for: .normal)
                    }
                    cell.inputField.isUserInteractionEnabled = true
                    cell.changeMobileButton.isHidden = false
                    cell.changeMobileButton.addTarget(self, action: #selector(changeMobileButtonAction(_:)), for: .touchUpInside)
                }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ProfileDropDownCell, for: indexPath) as? ProfileDropDownCell else {
                    return UITableViewCell()
                }
                cell.title.text = secondSection[indexPath.row]
                if indexPath.row == 2 {
                    if let gender = profileDict[UpdateProfileKeys.gender.rawValue] as? String , !gender.isEmpty {
                        cell.buttonDropDown.setTitle(gender, for: .normal)
                    } else {
                        cell.buttonDropDown.setTitle(Titles.gender, for: .normal)
                    }
                    cell.buttonDropDown.setTitleColor(.black, for: .normal)
                    cell.buttonDropDown.backgroundColor = .clear
                    cell.buttonDropDown.contentHorizontalAlignment = .left
                    cell.buttonDropDown.addTarget(self, action: #selector(genderButtonAction(_:)), for: .touchUpInside)
                } else  {
                    if let dob = profileDict[UpdateProfileKeys.DOB.rawValue] as? String, !dob.isEmpty {
                        cell.buttonDropDown.setTitle(dob, for: .normal)
                    } else {
                        cell.buttonDropDown.setTitle(Titles.dob, for: .normal)
                    }
                    cell.buttonDropDown.setTitleColor(.darkGray, for: .normal)
                    cell.buttonDropDown.backgroundColor = UIColor(hexString: "#CCCCCC")
                    cell.buttonDropDown.contentHorizontalAlignment = .center
                    cell.buttonDropDown.addTarget(self, action: #selector(dobButtonAction(_:)), for: .touchUpInside)
                    cell.buttonDropDown.setRadius(4)
                    cell.layoutIfNeeded()
                }
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 3 {
            let selectVC = SelectCityVC()
            selectVC.mainCategoryID = Int.getInt(profileDict[UpdateProfileKeys.state_id.rawValue]) == 0 ? -1 : Int.getInt(profileDict[UpdateProfileKeys.state_id.rawValue])
            selectVC.subCategoryID = Int.getInt(profileDict[UpdateProfileKeys.city_id.rawValue]) == 0 ? -1 : Int.getInt(profileDict[UpdateProfileKeys.city_id.rawValue])
            navigationController?.pushViewController(selectVC, animated: true)
        } else if indexPath.section == 0 && indexPath.row == firstSection.count - 1 {
            openActionSheet()
        }
    }
    
    @objc func genderButtonAction(_ sender: UIButton) {
        let alertController = UIAlertController(title:"Select Gender", message: nil, preferredStyle: .actionSheet)
        let maleAction = UIAlertAction(title: Titles.male, style: .default) { (action) in
            self.profileDict[UpdateProfileKeys.gender.rawValue] = Titles.male
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
        
        let femaleAction = UIAlertAction(title: Titles.female, style: .default) { (action) in
            self.profileDict[UpdateProfileKeys.gender.rawValue] = Titles.female
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: Titles.cancel, style: .cancel, handler: nil)
        alertController.addAction(maleAction)
        alertController.addAction(femaleAction)
        alertController.addAction(cancelAction)
        alertController.view.tintColor = .darkGray
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func dobButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        if let datePickerView = Bundle.main.loadNibNamed(ReuseIdentifier.CustomDatePickerView, owner: self, options: nil)?.first as? CustomDatePickerView {
            datePickerView.frame = view.frame
            datePickerView.delegate = self
            datePickerView.layoutIfNeeded()
            view.addSubview(datePickerView)
            datePickerView.topConstraint.constant = kScreenHeight
            datePickerView.animateView(isAnimate: true)
        }
    }
    
    @objc func changeMobileButtonAction(_ sender: UIButton) {
        let mobileVC = ChangeMobileVC.instantiate(fromAppStoryboard: .registration)
        mobileVC.delegate = self
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(mobileVC, animated: true)
        }
    }
}
