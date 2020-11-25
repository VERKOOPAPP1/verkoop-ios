//
//  UINavigationController+Extension.swift
//  GymClass
//
//  Created by Vijay's Macbook on 06/09/18.
//  Copyright © 2018 MobileCoderz5. All rights reserved.
//

import UIKit
extension UINavigationController {
    func setBottomShadow(){
        navigationBar.layer.masksToBounds = false
        navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationBar.layer.shadowOpacity = 0.8
        navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        navigationBar.layer.shadowRadius = 10
    }
    
    func available(viewController: AnyClass)-> UIViewController?{
        for vc in viewControllers {
            if vc.isKind(of: viewController)  {
                return vc
            }            
        }
        return nil
    }
    
    func containsViewController(ofKind kind: AnyClass) -> Bool{
        return self.viewControllers.contains(where: { $0.isKind(of: kind) })
    }   
}
