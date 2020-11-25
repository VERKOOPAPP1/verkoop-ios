//
//  AddDetail+Protocols.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 13/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

@objc protocol AddDetailDelegate {
    @objc optional func didNavigateToProfileScreen()
    @objc optional func selectUsedUnusedType(isNew: Int)
    @objc optional func didCategorySelected(id: Int, categoryName: String, parent_name: String, type: Int)
    @objc optional func meetupLocation(latitude: String, longitude: String, address: String)
    @objc optional func didSelectPropertyType(propertyType: String)
}

protocol CheckBoxDelegate: class {
    func didSelectParkingType(parkingType: String, cellType: CellTypeUsed)
}

//MARK:- Private Delegates
//MARK:-

extension AddDetailVC: AddDetailDelegate, CheckBoxDelegate {
    
    func didSelectParkingType(parkingType: String, cellType: CellTypeUsed) {
        switch cellType {
        case .parking:
            addDetailDict[AddDetailDictKeys.parking_type.rawValue] = parkingType
        case .furnished:
            addDetailDict[AddDetailDictKeys.furnished.rawValue] = parkingType
        case .transmission:
            addDetailDict[AddDetailDictKeys.transmission_type.rawValue] = parkingType
        case .ownerShip:
            addDetailDict[AddDetailDictKeys.direct_owner.rawValue] = parkingType
        }
//        enableAppyButton()
    }
    
    func didSelectPropertyType(propertyType: String) {
        addDetailDict[AddDetailDictKeys.property_type.rawValue] = propertyType
//        enableAppyButton()
    }
    
    func didNavigateToProfileScreen() {
        let navigation = self.navigationController
        for controller in navigation!.viewControllers {
            if controller.isKind(of: DashboardTabBarController.self) {
                self.delay(time: 0.1) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.SwitchTabBarController), object: nil, userInfo: ["index": 2, "nav": ""])
                }
                self.navigationController?.popToViewController(controller, animated: true)
             }
        }
    }
    
    func didCategorySelected(id: Int, categoryName: String, parent_name: String, type: Int) {        
        addDetailDict[AddDetailDictKeys.category_id.rawValue] = String.getString(id)
        addDetailDict[AddDetailDictKeys.category_name.rawValue] = categoryName
        addDetailDict[AddDetailDictKeys.parent_name.rawValue] = parent_name
        itemType = ItemType(rawValue: type)!
        if type == ItemType.generic.rawValue {
            tableView.reloadData()
            tableView.reloadSections(IndexSet(1..<genericSection.count - 1), with: .automatic)
        } else if type == ItemType.car.rawValue {
            if let owner = addDetailDict[AddDetailDictKeys.direct_owner.rawValue] as? String {
                addDetailDict[AddDetailDictKeys.direct_owner.rawValue] = owner
            } else {
                addDetailDict[AddDetailDictKeys.direct_owner.rawValue] = "1"
            }
            tableView.reloadData()
            tableView.reloadSections(IndexSet(0..<carSection.count), with: .automatic)
        } else if type == ItemType.property.rawValue || type == ItemType.rentals.rawValue {
            tableView.reloadData()
            tableView.reloadSections(IndexSet(1..<propertySection.count - 1), with: .automatic)
        }
        
//        self.enableAppyButton()
    }
    
    func selectUsedUnusedType(isNew: Int) {
        if isNew == 1 {
            addDetailDict[AddDetailDictKeys.item_type.rawValue] = (isNew as AnyObject).stringValue
        } else {
            addDetailDict[AddDetailDictKeys.item_type.rawValue] = (isNew as AnyObject).stringValue
        }
//        self.enableAppyButton()
    }
}

//MARK:- Location Manager Delegates
//MARK:-

extension AddDetailVC : CustomLocationManagerDelegate {
    
    func accessDenied() {
        let sender = UIButton()
        sender.isSelected = true
        checkButtonTapped(sender)
        
        DispatchQueue.main.async {
            let actionSheet = UIAlertController(title: "You have denied the permission to access Location", message: nil, preferredStyle: .alert)
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                actionSheet.dismiss(animated: true)
                self.navigationController?.popViewController(animated: true)
            }))
            actionSheet.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { action in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }))
            self.present(actionSheet, animated: true)
        }
    }
    
    func accessRestricted() {
        let sender = UIButton()
        sender.isSelected = true
        checkButtonTapped(sender)
    }
    
    func fetchLocation(location: CLLocation) {
        OperationQueue.main.addOperation {
            let vc = SelectMeetupLocationVC()
            vc.getNearBylocation(latLong: location.coordinate.latitude.description + "," + location.coordinate.longitude.description)
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func meetupLocation(latitude: String, longitude: String, address: String) {
        addDetailDict[AddDetailDictKeys.address.rawValue] = address
        addDetailDict[AddDetailDictKeys.latitude.rawValue] = latitude
        addDetailDict[AddDetailDictKeys.longitude.rawValue] = longitude
        OperationQueue.main.addOperation {
            self.tableView.reloadSections(IndexSet(arrayLiteral: 4), with: .automatic)
        }
//        enableAppyButton()
    }
}

extension AddDetailVC: DidSelectPhotosDelegate {
    func didPhotosSelected(photos: [Photos]) {
        let previousPhotos = photoAsset.filter { (photo) -> Bool in
            return photo.imageUrl != nil
        }
        photoAsset = previousPhotos
        photoAsset.append(contentsOf: photos)
        addDetailDict[AddDetailDictKeys.image.rawValue] = photoAsset
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TableCellSelectedPhotos {
            OperationQueue.main.addOperation {
                self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
                cell.collectionSelectedPhoto.reloadData()
            }
        }
//        enableAppyButton()
    }
}

extension AddDetailVC: MobileNumberVerifiedDelegate {
    func didMobileNumberVerified() {
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .automatic)
        }
    }
}
