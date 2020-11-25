//
//  PackageVC+Protocols.swift
//  Verkoop
//
//  Created by Vijay on 04/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

extension SelectPackageVC: SubmitBannerDelegate {    
    func didClosePopup() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(NotificationName.BannerSubmited), object: nil, userInfo: ["bannerSubmitted":"1"])
            if let controllers = self.navigationController?.viewControllers {
                for controller in controllers {
                    if controller.isKind(of: BannerListVC.self) {
                        self.navigationController?.popToViewController(controller, animated: true)
                    }
                }
            }
        }
    }
}
