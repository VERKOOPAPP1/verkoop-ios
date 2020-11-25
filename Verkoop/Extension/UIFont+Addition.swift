//
//  UIFont+Extension.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 15/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import UIKit
extension UIFont {
    class func printFontFamily(){
        for family in UIFont.familyNames {
            print("\(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("----\(name)")
            }
        }
    }
    
    static func kAppDefaultFontBold(ofSize size: CGFloat = 16) -> UIFont {
        return UIFont(name: "CenturyGothic-Bold", size: size)!
    }
    
    static func kAppDefaultFontRegular(ofSize size: CGFloat = 16) -> UIFont {
        return UIFont(name: "CenturyGothic", size: size)!
    }
    
    static func kAppDefaultFontMedium(ofSize size: CGFloat = 16) -> UIFont {
        return UIFont(name: "CenturyGothic", size: size)!
    }
}
/*
 Century Gothic
 ----CenturyGothic
 ----CenturyGothic-Bold
 ----CenturyGothic-BoldItalic
 ----CenturyGothic-Italic

 */
