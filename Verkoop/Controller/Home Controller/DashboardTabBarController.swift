//
//  DashboardTabBarController.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 05/12/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import UIKit
import SocketIO

class DashboardTabBarController: UITabBarController, UITabBarControllerDelegate  {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.unselectedItemTintColor = UIColor(hexString: "E79093")
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.kAppDefaultFontBold(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.kAppDefaultFontBold(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor(hexString: "#e5a6a7")], for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(switchTabBar(_:)), name: NSNotification.Name(rawValue: NotificationName.SwitchTabBarController), object: nil)
        SocketHelper.shared.connect()
    }
    
    @objc func refreshData(_ notification: Notification) {
        if let _ = notification.userInfo {
            
        }
    }
    
    @objc func switchTabBar(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let index = userInfo["index"] as? Int {
                delay(time: 0.3) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.RefreshController), object: nil, userInfo: nil)
                }
                selectedIndex = index
            }
        }
    }
}

