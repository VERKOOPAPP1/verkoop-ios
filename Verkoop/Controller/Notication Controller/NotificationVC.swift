//
//  NotificationVC.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 26/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func emailNotificationSwitch(_ sender: UISwitch) {
        sender.isOn = !sender.isOn
    }
    
    @IBAction func pushNotificationSwift(_ sender: UISwitch) {
        sender.isOn = !sender.isOn
    }
    
}
