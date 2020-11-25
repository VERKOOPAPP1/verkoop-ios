//
//  UIColor+Addition.swift
//  GymClass
//
//  Created by MobileCoderz5 on 8/23/18.
//  Copyright © 2018 MobileCoderz5. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
//    public convenience init?(hexString: String) {
//        let r, g, b: CGFloat
//
//        if hexString.hasPrefix("#") {
//            let start = hexString.index(hexString.startIndex, offsetBy: 1)
//            let hexColor = String(hexString[start...])
//            let scanner = Scanner(string: hexColor)
//            var hexNumber: UInt64 = 0
//            if scanner.scanHexInt64(&hexNumber) {
//                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
//                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
//                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
//
//                self.init(red: r, green: g, blue: b, alpha: 1)
//                return
//            }
//        }
//        return nil
//    }
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    var hexString: String {
        let components = self.cgColor.components
        
        let red = Float(components![0])
        let green = Float(components![1])
        let blue = Float(components![2])
        return String(format: "#%02lX%02lX%02lX", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255))
    }
    
    struct AppColor {
        static let appGray = UIColor(hexString: "#a2a2a2")
        static let appLightBlack = UIColor(hexString: "#222222")
        static let appGrayBg = UIColor(hexString: "#efefef")
        static let appLightBlackOther = UIColor(hexString: "#696969")
    }
    
    class func getRGBColor(_ r:CGFloat,g:CGFloat,b:CGFloat)-> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }

}
