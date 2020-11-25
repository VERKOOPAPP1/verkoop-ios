//
//  Profile+VC.swift
//  NotificationScreen
//
//  Created by deepak on 26/03/19.
//  Copyright © 2019 deepak. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {
    
    let tableSection = ["Account Setting", "Need Help", "About This App", " Logout"]
    let firstSectionData = ["Edit profile", "Change Password", "Notification", "Data & Privacy Setting"]
    let secondSectionData = ["Help Center","Contact Us","About Verkoop"]
    let thirdSectionData = ["Term Of Service","Privacy Policy","Deactivate Account"]
    let fourthSectionData = ["Banner", "Logout"]
    
    @IBOutlet weak var tableView: UITableView!
    
    let sectionArray = [["", "", "", "http://verkoopadmin.com/VerkoopApp/app/privacySettings"], [ "http://verkoopadmin.com/VerkoopApp/app/helpCenter", "http://verkoopadmin.com/VerkoopApp/app/contactUs", "http://verkoopadmin.com/VerkoopApp/app/about"], ["http://verkoopadmin.com/VerkoopApp/app/termsOfConditions", "http://verkoopadmin.com/VerkoopApp/app/privacyPolicy"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    fileprivate func initialSetUp() {
        tableView.register(UINib(nibName: ReuseIdentifier.SingleLabelCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.SingleLabelCell)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
