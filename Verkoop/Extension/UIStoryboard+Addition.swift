//
//  UIStoryboard+extension.swift
//  Verkoop
//
//  Created by Vijay on 01/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

enum AppStoryboard : String {
    
    case registration = "Registration"
    case selection = "Selection"
    case home = "Home"
    case categories = "Categories"
    case profile = "Profile"
    case chat = "Chat"
    case advertisement = "Advertisement"
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
    
}
