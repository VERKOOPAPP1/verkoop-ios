//
//  EditProfileVC+PhotoDelegates.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 27/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
import UIKit

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openActionSheet() {
        openMediaActionSheet { (camera:Bool, gallery:Bool) in
            if camera {
                self.openCamera(completionHandler: { (success:Bool, error:NSError?) in
                    if let error = error {
                        OperationQueue.main.addOperation {
                            DisplayBanner.show(message: error.localizedDescription)
                        }
                        return
                    }
                    if success {
                        OperationQueue.main.addOperation {
                            self.openImagePicker(sourceType: .camera)
                        }
                    }
                })
            } else {
                self.openGallery(completionHandler: { (success:Bool, error:NSError?) in
                    if let error = error {
                        OperationQueue.main.addOperation {
                            DisplayBanner.show(message: error.localizedDescription)
                        }
                        return
                    }
                    if success {
                        OperationQueue.main.addOperation {
                            self.openImagePicker(sourceType: .photoLibrary)
                        }
                    }
                })
            }
        }
    }
    
    func openImagePicker(sourceType:  UIImagePickerController.SourceType) {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = sourceType
        self.imagePicker.delegate = self
        OperationQueue.main.addOperation({
            self.present(self.imagePicker, animated: true, completion: nil)
        })
    }
    
    //MARK:- ImagePickerController Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // Bug in iOS. The image auto rotates itself. So, in order to fix, image scaling + rotation is done
            userImage = pickedImage.rotateImageWithScaling()
            let indexPath = IndexPath(row: firstSection.count - 1, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? ProfilePhotoCell {
                DispatchQueue.main.async {
                    cell.profileImage.image = self.userImage
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension EditProfileVC {
    @objc func getSelectedCity(_ notification: Notification) {
        if let dict = notification.userInfo {
            profileDict[UpdateProfileKeys.city.rawValue] = String.getString(dict["city_name"])
            profileDict[UpdateProfileKeys.state.rawValue] = String.getString(dict["state_name"])
            profileDict[UpdateProfileKeys.city_id.rawValue] = String.getString(dict["city_id"])
            profileDict[UpdateProfileKeys.state_id.rawValue] = String.getString(dict["state_id"])
            profileDict[UpdateProfileKeys.country_id.rawValue] = String.getString(dict["country_id"])
            profileDict[UpdateProfileKeys.country.rawValue] = String.getString(dict["country_name"])
            tableView.reloadData()
        }
    }
}

extension EditProfileVC: DatePickerDelegates {
    func didPickedDate(dateString: String) {
        profileDict[UpdateProfileKeys.DOB.rawValue] = dateString
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
    }
}

extension EditProfileVC: MobileNumberVerifiedDelegate {
    func didMobileNumberVerified() {
        profileDict[UpdateProfileKeys.mobile.rawValue] = Constants.sharedUserDefaults.getUserMobile()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
