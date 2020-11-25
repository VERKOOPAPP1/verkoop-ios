//
//  EditProfileVC.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 26/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let sectionData = ["Public Profile", "Private Profile"]
    let firstSection = ["Username", "First Name", "Last Name", "My City", "WebSite", "Bio", "Profile Photo"]
    let secondSection = ["Email", "Mobile", "Gender", "Birthday"]
    var profileDict : Dictionary<String, Any> = [:]
    var imagePicker = UIImagePickerController()
    var userImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    fileprivate func initialSetUp() {
        tableView.register(UINib(nibName: ReuseIdentifier.ProfileDropDownCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.ProfileDropDownCell)
        tableView.register(UINib(nibName: ReuseIdentifier.ProfileTextFieldCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.ProfileTextFieldCell)
        tableView.register(UINib(nibName: ReuseIdentifier.ProfilePhotoCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.ProfilePhotoCell)
                
        profileDict[UpdateProfileKeys.city_id.rawValue] = Constants.sharedUserDefaults.getUserCityID()
        profileDict[UpdateProfileKeys.state_id.rawValue] = Constants.sharedUserDefaults.getUserStateID()
        profileDict[UpdateProfileKeys.state.rawValue] = Constants.sharedUserDefaults.getUserState()
        profileDict[UpdateProfileKeys.city.rawValue] = Constants.sharedUserDefaults.getUserCity()
        profileDict[UpdateProfileKeys.username.rawValue] = Constants.sharedUserDefaults.getUserName()
        profileDict[UpdateProfileKeys.email.rawValue] = Constants.sharedUserDefaults.getUserEmail()
        profileDict[UpdateProfileKeys.mobile.rawValue] = Constants.sharedUserDefaults.getUserMobile()
        profileDict[UpdateProfileKeys.user_id.rawValue] = Constants.sharedUserDefaults.getUserId()
        profileDict[UpdateProfileKeys.first_name.rawValue] = Constants.sharedUserDefaults.getFirstName()
        profileDict[UpdateProfileKeys.last_name.rawValue] = Constants.sharedUserDefaults.getLastName()
        profileDict[UpdateProfileKeys.bio.rawValue] = Constants.sharedUserDefaults.getBio()
        profileDict[UpdateProfileKeys.profile_pic.rawValue] = Constants.sharedUserDefaults.getUserImage()
        profileDict[UpdateProfileKeys.gender.rawValue] = Constants.sharedUserDefaults.getUserGender()
        profileDict[UpdateProfileKeys.DOB.rawValue] = Constants.sharedUserDefaults.getUserDOB()
        profileDict[UpdateProfileKeys.website.rawValue] = Constants.sharedUserDefaults.getWebsite()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getSelectedCity(_:)), name: NSNotification.Name(NotificationName.GetSelectedCity), object: nil)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        view.endEditing(true)
        if let profileImage = userImage {
            profileDict[UpdateProfileKeys.profile_pic.rawValue] = profileImage.jpeg(.high)
            updateProfileService(params: profileDict)
        } else {
            profileDict.removeValue(forKey: UpdateProfileKeys.profile_pic.rawValue)
            updateProfileService(params: profileDict)
        }
    }
}
